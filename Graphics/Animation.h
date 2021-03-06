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

#pragma once
#ifndef _ANIMATION_H
#define _ANIMATION_H
#include "../Root/Physics.h"
#include "Texture.h"

#include <SFML/OpenGL.hpp>

using namespace Gfx;

class AnimationBase : public Body
{
    // we can add implementation to support lighting and material attributes here
protected:
    float LightingColor[4];
    float mUV[8]; // texture offsets 4 pairs

public:
    AnimationBase(int w, int h);
    virtual ~AnimationBase();

    inline const float* GetUVs() { return mUV; }

    inline void SetLightingColor(const float lc[4])
    {
        LightingColor[0] = lc[0] / 256; // todays cpus optimize this faster than a call to mem copy.
        LightingColor[1] = lc[1] / 256;
        LightingColor[2] = lc[2] / 256;
        LightingColor[3] = lc[3] / 256;
    }
    inline float* GetLightingColor() { return LightingColor; }
    inline void SetWidth(float w) { mWidth.x = w; }
    virtual void BindTexture() = 0;
    virtual void ClearFrames(){};
    virtual void Update(float dt){};
    virtual void SetUVs(const float uvs[8]);
};

class AnimationShape : public AnimationBase
{
public:
    AnimationShape(int width, int height);
    virtual void BindTexture() {}
};

class Animation : public AnimationBase
{
private:
    std::vector<std::pair<Texture*, float>> mFrames;
    unsigned int mCurrentFrame;

public:
    Animation(int width, int height);

    void AddFrame(Texture* pTex, float duration);
    void ClearFrames();
    void Update(float dt);
    void BindTexture();
};

class AnimationSingle : public AnimationBase
{
    Texture* mpTexture;

public:
    AnimationSingle(Texture* pTex, int width, int height);
    void SetSubRect(int x1, int y1, int x2, int y2);
    void BindTexture();
};

class AnimationEmpty : public AnimationBase
{
public:
    AnimationEmpty(int width, int height);
    void BindTexture(){};
};
#endif
