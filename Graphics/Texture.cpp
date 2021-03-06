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

#include "Texture.h"

#include "ErrorImage.h"

#include <iostream>

using namespace Gfx;

Texture::Texture(const string& pszName)
{
    mName = pszName;
    //   mID = 0;
}

bool Texture::Load(const string& pszName)
{
    if (!loadFromFile(pszName)) {
        if (!loadFromFile("data/Error.png")) {
            create(64, 64);
            update(ErrorImagePixels);
        }
    }
    setSmooth(true);
    bind(this);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT); // setup for the tiler or animation
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    return true;
}
