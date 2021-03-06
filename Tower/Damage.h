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

// burned out shell, nothing to see move along
#pragma once
#ifndef _DAMAGE_H
#define _DAMAGE_H

#include "../Graphics/FireAnimation.h"
#include "../Graphics/ModelObject.h"
#include "FloorBase.h"

#include <string>

class AnimationSingle;
class Tower;

class Damage : public FloorBase, public Gfx::ModelObject
{
protected:
    AnimationSingle* mpFrame;
    FireAnimation mFire;

public:
    Damage(int x, int x2, int level, Tower* TowerParent, AnimationSingle* pFrame);

    static BaseType GetBaseType() { return BaseEmpty; }
    std::string GetTypeName() const override { return "damage"; }
    void Update(float dt, int tod);
    void Draw();
    void DrawFramework();
};

#endif //_DAMAGE_H
