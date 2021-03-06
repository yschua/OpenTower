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

#ifndef _TILER_H
#define _TILER_H
#include "../Graphics/Texture.h"

using namespace Gfx;

class Tiler
{
private:
    bool mClipMode;
    float mX;
    float mY;
    float mZ;
    float mWidth;
    float mHeight;
    float mTesselX;
    float mTesselY;
    float LightingColor[4];
    // int mImageSizeX, mImageSizeY;
    //   sf::Image * mframe;
    Texture* mpTexture;

public:
    enum draw_direction { Horizontal, Vertical };
    draw_direction mdirection;
    //   Tiler (sf::Image * image, draw_direction direction, int x, int x2, int y);
    Tiler(Texture* pTex, draw_direction direction, float x, float y, float z, float width, float height);
    void SetY(int y);
    float GetTesselX() { return mTesselX; }
    float GetTesselY() { return mTesselY; }
    float GetPositionX() { return mX; }
    float GetPositionY() { return mY; }
    float GetPositionZ() { return mZ; }
    float GetWidth() { return mWidth; }
    float GetHeight() { return mHeight; }
    inline void BindTexture() { sf::Texture::bind(mpTexture); }

    //   void SetImage (sf::Image * image);
    void SetTexture(Texture* pTex) { mpTexture = pTex; }
    void SetTessel(float x, float y)
    {
        mTesselX = x;
        mTesselY = y;
    }
    inline void SetLightingColor(const float lc[4])
    {
        LightingColor[0] = lc[0] / 256; // todays cpus optimize this faster than a call to mem copy.
        LightingColor[1] = lc[1] / 256;
        LightingColor[2] = lc[2] / 256;
        LightingColor[3] = lc[3] / 256;
    }
    inline float* GetLightingColor() { return LightingColor; }

    void CalcPos();
    void Resize(int x, int x2, int tesx, int tessy);
    //   std::vector <AnimationSingle *> mSprites;
    void SetClipping(bool clipping_mode);
};

#endif
