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

#include "SingleStair.h"

#include "../Graphics/Animation.h"
#include "../Graphics/Image.h"
#include "../Graphics/Tiler.h"
#include "../Root/HighRiseException.h"
#include "../Root/Physics.h"
#include "../Root/SerializerBase.h"
#include "RouteBase.h" // SingleStairs route (levels).

#include <cstdlib>
#include <cstring>
#include <iostream>
#include <map>

using namespace Gfx;

namespace TowerObjects
{
int gStairsNumber = 1; // start with 1 to keep engineers happy
};

using namespace TowerObjects;
// const int SingleStair::mStandingPositions[16] =
//{
//   12,20,16,4,18,22,6,24,8,10,2,5,9,13,17,21
//};

SingleStair::SingleStair(int x, short BottomLevel, short TopLevel, Tower* TowerParent) : Body(27, 36)
{
    mTowerParent = TowerParent;
    mTopLevel = TopLevel;
    mBottomLevel = BottomLevel;

    mFloorCount = TopLevel - BottomLevel;
    mWalkersOnStairs = 0;
    mMaxCap = 12;

    mX = x;
    mY = (int)(mBottomLevel * 36);
    mZ = -0.69f; // slightly in front of the tower

    mNumber = gStairsNumber++; // set number;
    LoadImages();
}

SingleStair::SingleStair(SerializerBase& ser, short TopLevel, Tower* TowerParent) :
    Body(27, 36),
    mTowerParent(TowerParent)
{
    //"type", "standard SingleStair"
    mNumber = ser.GetInt("number");
    mX = ser.GetInt("startx");
    mY = ser.GetInt("starty");
    mZ = ser.GetFloat("startz");
    mTopLevel = (short)ser.GetInt("toplevel");
    mBottomLevel = (short)ser.GetInt("bottomlevel");
    mWalkersOnStairs = (short)ser.GetInt("walkersonstairs");
    mMaxCap = (short)ser.GetInt("maxcap");
    LoadImages();
}

SingleStair::~SingleStair()
{
    delete mSingleStairImage;
};

void SingleStair::LoadImages()
{
    ImageManager* images = ImageManager::GetInstance();
    mSingleStairImage = new AnimationSingle(images->GetTexture("SingleStair.png", GL_RGBA), 27, 36);
    mSingleStairImage->SetPosition(static_cast<float>(mX), static_cast<float>(-mY));
}

void SingleStair::PosCalc()
{
    mSingleStairImage->SetPosition((float)mX, (float)mY); // SingleStair sprite is only 32x32
}

int SingleStair::LoadPerson(Person* person, int to ) // returns space remaining
{
    if (mWalkersOnStairs < mMaxCap) {
        //      mRiders[mWalkersOnStairs].mDestLevel = destLevel;
        //      mRiders[mWalkersOnStairs].mPerson = person;
        mWalkersOnStairs++;
    }
    return mMaxCap - mWalkersOnStairs;
}

void SingleStair::Motion() {}

// SingleStair is either in motion or idle( doors open, loading, unloading, no calls )
// When idle do nothing. Idle times are set when the SingleStair arrives at a floor
// When idle cycle ends scan for destinations and calls.
void SingleStair::Update(float dt) {}

void SingleStair::Draw()
{
    Render(mSingleStairImage);
}

void SingleStair::Save(SerializerBase& ser)
{
    ser.Add("type", "standard SingleStair");
    ser.Add("number", mNumber);
    ser.Add("startx", mX);
    ser.Add("starty", mY);
    ser.Add("startz", mZ);
    ser.Add("toplevel", mTopLevel);
    ser.Add("bottomlevel", mBottomLevel);
    ser.Add("walkersonstairs", mWalkersOnStairs);
    ser.Add("maxcap", mMaxCap);
}