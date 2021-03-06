/*   This file is part of Highrise Developer.
 *
 *   Foobar is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.

 *   Highrise Developer is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "Elevator.h"

#include "../Graphics/Animation.h"
#include "../Graphics/Image.h"
#include "../Graphics/Tiler.h"
#include "../People/Person.h"
#include "../Root/HighRiseException.h"
#include "../Root/Physics.h"
#include "../Root/SerializerBase.h"
#include "ElevatorBase.h"
#include "ElevatorMachine.h"
#include "ElevatorShaft.h"
#include "../Tower/Level.h"
#include "PersonQueue.h"
#include "RouteBase.h" // Elevators route (levels).
#include "../Tower/Tower.h"

#include <cstdlib>
#include <cstring>
#include <iostream>
#include <map>

int Elevator::m_nextId = 0;

Elevator::Elevator(LiftStyle type, int x, int bottomLevel, int topLevel, Tower* tower) :
    Body(32, 32),
    m_id(m_nextId++),
    m_type(type),
    m_tower(tower),
    m_dirUp(true),
    m_idle(true),
    m_stop(true)
{
    m_topLevel = topLevel;
    m_bottomLevel = bottomLevel;
    m_carPosition = m_bottomLevel * 36;
    m_maxRiders = (m_type == LS_HighCapacity) ? 30 : 15;

    mX = x + 2;
    mY = m_bottomLevel * 36;
    mZ = -0.49f; // slightly in front of the tower

    LoadImages();
    InitQueues();
    InitStopLevels();
}

Elevator::~Elevator()
{
    delete mElevatorImage;
    delete mRiderImage;
    delete mLiftMachine;
    delete mLiftPit;
    delete mElevatorShaft;
};

void Elevator::LoadImages()
{
    ImageManager* images = ImageManager::GetInstance();
    const char* pImageName = "Elevator_u_n.png";

    switch (m_type) {
    case LS_Standard:
        mWidth.x = 32;
        break;
    case LS_HighCapacity:
        mWidth.x = 41;
        pImageName = "Elevator_u_w.png";
        break;
    case LS_Freight:
        mWidth.x = 32;
        pImageName = "Elevator_u_s.png";
        break;
    case LS_Express:
        mWidth.x = 32;
        pImageName = "Elevator_o_x.png";
        break;
    }

    mElevatorImage = new AnimationSingle(images->GetTexture(pImageName, GL_RGBA),
                                         static_cast<int>(mWidth.x),
                                         static_cast<int>(mHeight.y));

    mRiderImage = new AnimationSingle(images->GetTexture("Person_e.png", GL_RGBA), 8, 16);

    mRiderImage->SetPosition((float)mX + 8,
                             (float)(m_bottomLevel - 1) * -36); // neg 36 so it becomed positive for model view

    mLiftMachine = new ElevatorMachine(mX - 2,
                                       m_topLevel + 1,
                                       static_cast<int>(mWidth.x + 4),
                                       this);

    mLiftPit = new AnimationSingle(images->GetTexture("LiftPit_1.png", GL_RGBA),
                                   static_cast<int>(mWidth.x + 4), 36);

    mLiftPit->SetPosition((float)mX - 2,
                          (float)(m_bottomLevel - 1) * -36); // neg 36 so it becomed positive for model view

    mElevatorShaft = new ElevatorShaft(mX - 2,
                                       m_topLevel,
                                       m_bottomLevel - 1,
                                       static_cast<int>(mWidth.x + 4),
                                       this);
}

void Elevator::InitStopLevels()
{
    for (int level = m_bottomLevel; level <= m_topLevel; level++) {
        m_callButtons.insert(std::make_pair(level, CallButton()));
        m_floorButtons.insert(std::make_pair(level, FloorButton()));
    }
}

void Elevator::PosCalc()
{
    const int offset = m_bottomLevel * 36; // adjust for starting floor.
    // elevator sprite is only 32x32
    mElevatorImage->SetPosition((float)mX, (float)(mY - (offset + m_carPosition) + 4));
    mRiderImage->SetPosition((float)mX, (float)(mY - (offset + m_carPosition) + 18));
}

void Elevator::SetFloorButton(int to) // OK, take me there
{
    m_floorButtons[to].m_stopping = true;
}

bool Elevator::SetCallButton(int from, int to)
{
    bool isOnFloor = false;

    if (GetCurrentLevel() == from && CanStop()) {
        SetFloorButton(to);
        isOnFloor = true;
    } else {
        if (to > from) {
            m_callButtons[from].m_callUp = true;
        } else {
            m_callButtons[from].m_callDown = true;
        }
    }
    return isOnFloor;
}

int Elevator::LoadPerson(Person* person, int to)
{
    if (GetNumRiders() < m_maxRiders) {
        m_riders.push_back(Rider{person, to});
        std::cout << "load " << person->GetId() << " to: " << to << "\n";
        SetFloorButton(to);
    }
    return m_maxRiders - GetNumRiders();
}

Person* Elevator::UnloadPerson()
{
    for (auto it = m_riders.begin(); it != m_riders.end(); ++it) {
        if (it->m_destLevel == GetCurrentLevel()) {
            auto person = it->m_person;
            m_riders.erase(it);
            std::cout << "unload " << person->GetId() << " at: " << GetCurrentLevel() << "\n";
            return person;
        }
    }
    return nullptr;
}

// TODO std::optional
std::pair<bool, int> Elevator::FindNearestCall() const
{
    // search outwards from current level
    int up = GetCurrentLevel() + 1;
    int down = GetCurrentLevel() - 1;
    bool searchUp = true;
    while (up <= m_topLevel || down >= m_bottomLevel) {
        int level = (searchUp) ? up : down;
        if (m_callButtons.at(level).m_callDown) {
            return std::make_pair(true, level);
        }
        if (m_callButtons.at(level).m_callUp) {
            return std::make_pair(true, level);
        }

        if (searchUp) {
            up++;
            if (down >= m_bottomLevel) searchUp = false;
        } else {
            down--;
            if (up <= m_topLevel) searchUp = true;
        }
    }
    return std::make_pair(false, 0);
}

bool Elevator::KeepMovingInCurrentDirection() const
{
    if (m_dirUp) {
        for (int level = GetCurrentLevel() + 1; level <= m_topLevel; level++) {
            if (m_floorButtons.at(level).m_stopping ||
                m_callButtons.at(level).m_callDown ||
                m_callButtons.at(level).m_callUp) {
                return true;
            }
        }
    } else {
        for (int level = GetCurrentLevel() - 1; level >= m_bottomLevel; level--) {
            if (m_floorButtons.at(level).m_stopping ||
                m_callButtons.at(level).m_callDown ||
                m_callButtons.at(level).m_callUp) {
                return true;
            }
        }
    }
    return false;
}

int Elevator::GetNumLevels() const
{
    return static_cast<int>(m_floorButtons.size());
}

int Elevator::GetCurrentLevel() const
{
    return m_carPosition / 36;
}

bool Elevator::CanStop() const
{
    return m_carPosition % 36 == 0;
}

int Elevator::GetNumRiders() const
{
    return static_cast<int>(m_riders.size());
}

void Elevator::Motion()
{
    const int currentLevel = GetCurrentLevel();

    if (GetNumRiders() > 0) {
        m_idle = false;
    }

    if (m_idle) {
        // check for calls
        auto call = FindNearestCall();
        bool valid = call.first;
        if (valid) {
            m_idle = false;
            int callLevel = call.second;
            m_dirUp = (callLevel > currentLevel);
        }
    } else if (CanStop()) {
        // check if current level has call
        auto& callButton = m_callButtons[currentLevel];
        if (callButton.m_callDown || callButton.m_callUp) {
            callButton.m_callDown = callButton.m_callUp = false;
            m_stop = true;
        }
        
        // check if stopping on current level
        auto& floorButton = m_floorButtons[currentLevel];
        if (floorButton.m_stopping) {
            floorButton.m_stopping = false;
            m_stop = true;
        }

        // check remaining stops in both directions
        if (!m_stop && !KeepMovingInCurrentDirection()) {
            m_dirUp = !m_dirUp; // change direction
            if (!KeepMovingInCurrentDirection()) {
                m_idle = true;
            }
        }
    }

    if (!m_stop && !m_idle) {
        // moving
        m_carPosition += m_dirUp ? 1 : -1;
        mLiftMachine->Update(1);
    }

    PosCalc();
    mLiftMachine->Update(1);
}

void Elevator::Update(float dt)
{
    std::cout << "Elevator update without time called: " << std::endl;
}

// Elevator is either in motion or idle( doors open, loading, unloading, no calls )
// When idle do nothing. Idle times are set when the elevator arrives at a floor
// When idle cycle ends scan for destinations and calls.
void Elevator::Update(float dt, int tod)
{
    static int motionDelay = 0;

    if (!m_stop) {
        if (motionDelay-- <= 0) Motion();
        return;
    }

    // unload person from elevator
    auto personUnload = UnloadPerson();
    if (personUnload != nullptr) {
        personUnload->SetCurrent(GetCurrentLevel());
        return;
    }

    // load person on elevator from queue
    const int currentLevel = GetCurrentLevel();
    Person* personLoad;
    int to;
    std::tie(personLoad, to) = m_queues[currentLevel].TakeNextPerson();
    if (personLoad != nullptr) {
        LoadPerson(personLoad, to);
        return;
    }

    // initiate motion
    m_stop = false;
    motionDelay = 20;
}

void Elevator::Draw()
{
    const float ArrowDown[] = {-3.0f, -3.0f, 0.1f, 0.0f, -6.0f, 0.1f, 3.0f, -3.0f, 0.1f};
    const float ArrowUp[] = {-3.0f, 3.0f, 0.1f, 0.0f, 6.0f, 0.1f, 3.0f, 3.0f, 0.1f};
    const float ArrowDim[] = {0.1f, 0.4f, 0.1f, 0.7f};
    const float ArrowLit[] = {0.2f, 1.0f, 0.2f, 1.0f};
    const std::vector<int> standingPos = {12, 20, 16, 4, 18, 22, 6, 24, 8, 10, 2, 5, 9, 13, 17, 21};

    mElevatorShaft->Draw();
    mLiftMachine->Draw();
    Render(mLiftPit);
    Render(mElevatorImage);

    const size_t numRiders = static_cast<size_t>(GetNumRiders());
    for (size_t idx = 0; idx < std::min(numRiders, standingPos.size()); ++idx) {
        Render(mRiderImage,
               (float)(mX + standingPos[idx]),
               (float)(mX + standingPos[idx] + 8));
    }

    for (const auto& call : m_callButtons) {
        int level = call.first;
        const auto& callButton = call.second;

        RenderTriangle(
            ArrowUp,
            callButton.m_callUp ? ArrowLit : ArrowDim,
            mX + 4.f,
            level * 36.f - 12,
            0.f);

        RenderTriangle(
            ArrowDown,
            callButton.m_callDown ? ArrowLit : ArrowDim,
            mX + 4.f,
            level * 36.f - 12,
            0.f);
    }
}

void Elevator::Save(SerializerBase& ser)
{
}

void Elevator::InitQueues()
{
    for (int level = m_bottomLevel; level <= m_topLevel; level++) {
        m_queues.insert(std::make_pair(level, PersonQueue()));
    }
}

void Elevator::AddToQueue(int level, Person* person, int to)
{
    m_queues[level].AddPerson(person, to);
}

bool Elevator::StopsOnLevel(int level)
{
    return m_floorButtons.at(level).m_enabled;
}

int Elevator::FindLobby()
{
    return 0;
}

std::vector<int> Elevator::GetConnectedLevels() const
{
    std::vector<int> levels;
    for (const auto& floorButton : m_floorButtons) {
        if (floorButton.second.m_enabled) {
            levels.push_back(floorButton.first);
        }
    }
    return levels;
}