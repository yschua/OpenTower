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

#include "Animation.h"

#include <cstring>
#include <iostream>
#include <string>

// all things not in 3D space. Used for interface
using namespace Gfx;

namespace Gfx
{
// this defines the coordinates to map the texture image from in pairs
const float DefaultUVs[8] = {0.0f, 1.0f, 0.0f, 0.0f, 1.0f, 0.0f, 1.0, 1.0f};
}

AnimationBase::AnimationBase(int w, int h) : Body(w, h)
{
    SetUVs(Gfx::DefaultUVs);
}

AnimationBase::~AnimationBase() {}

void AnimationBase::SetUVs(const float uvs[8])
{
    memcpy(mUV, uvs, sizeof(mUV));
}
