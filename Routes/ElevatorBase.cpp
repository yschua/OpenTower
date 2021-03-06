/*   This file is part of Highrise Developer.
 *
 *   Highrise Developer is free software: you can redistribute it and/or modify
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
#include "ElevatorBase.h"

#include "../Graphics/Animation.h"
#include "../Graphics/Image.h"
#include "../Graphics/Tiler.h"
#include "../Root/Physics.h"
#include "Elevator.h"
#include "RouteBase.h"

#include <cstdlib>
#include <iostream>
#include <map>

using namespace Gfx;

ElevatorBase::ElevatorBase(int x, int level, Elevator* pElevator)
{
    mx = x;
    my = 0;
    mLevel = level;
    mpParent = pElevator;
}

ElevatorBase::~ElevatorBase() {}

void ElevatorBase::Update(float dt, int tod) {}

void ElevatorBase::Draw()
{
    //    Camera::GetInstance()->Draw (*manimations[mcurrent_state]);
}
