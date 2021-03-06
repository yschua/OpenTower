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
 *   along with Highrise Developer.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef _SINGLESTAIRS_H
#define _SINGLESTAIRS_H

// Elevator class, this is the elevator carrige.
// Handles the car movement and operations.
// Elevator is the overhead cable machine.
// LiftShaft is the evelator shaft.
// ListPit is the crash landing pit below in the event of a break failure.
// This three parts build the shaft for the elevator/lift to run in.

// these decls allow inclusion of this header without the need to load these class headers.
// class RouteBase;
class AnimationSingle;
class Person;
class PersonQueue;
class Tower;
class SerializerBase;

#include "../Graphics/ModelObject.h"
#include "../Root/Physics.h"
#include "RouteBase.h"

// people walk up and down these but will ride the elevators in most cases
namespace TowerObjects
{
class SingleStair : public Body, public RouteBase, public Gfx::ModelObject // Quad morphic
{
public:
protected:
    static int gElevatorsNumber;
    static const int mStandingPositions[];

    AnimationSingle* mSingleStairImage;

    // Controls this things motion
    int mX;
    int mY;
    float mZ;

    int mNumber; // number of this stair
    short mTopLevel;
    short mBottomLevel;

    short mWalkersOnStairs;
    short mFloorCount;
    short mMaxCap;

    Tower* mTowerParent;

public:
    // CTOR/DTOR  Use create to make on
    SingleStair(int x, short BottLevel, short TopLevel, Tower* TowerParent);
    SingleStair(SerializerBase& ser, short TopLevel, Tower* TowerParent);
    virtual ~SingleStair();
    static BaseType GetBaseType() { return BaseSingleStair; }
    static const char* GetTypeString() { return "singlestair"; }

    // Properties
    inline int GetNumber() { return mNumber; }

protected:
    void LoadImages();
    void PosCalc();

    int LoadPerson(Person* person, int to);
    void Motion();
    bool SetCallButton(int from, int to) override { return false; }
    void SetFloorButton(int to) override {}
public:
    virtual void Update(float dt);
    virtual void Draw();
    virtual void DrawFramework() {} // geometry test

    void Save(SerializerBase& ser);
    void AddToQueue(int level, Person* person, int to) override {}
};
}

#endif _SINGLESTAIRS_H
