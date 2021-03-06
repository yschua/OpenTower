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

#include "Tiler.h"

#include "../Root/HighRiseException.h"

Tiler::Tiler(Texture* pTex, draw_direction direction, float x, float y, float z, float width, float height)
{
    mpTexture = pTex;
    mClipMode = true;
    mX = x;
    // mX2 = x2;
    mY = y;
    mZ = z;
    mWidth = width;
    mHeight = height;
    mTesselX = 24; // These are done in hardware as fills
    mTesselY = 1;

    if (mpTexture == NULL) //(mImageSizeY * mImageSizeX) == 0 )
        throw new HighriseException("Missing image file");

    // Hardware shader does the work !
}

void Tiler::SetClipping(bool clipping_mode)
{
    mClipMode = clipping_mode;
}
