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

#include "Stats.h"

#include "../Graphics/Animation.h"
#include "../Graphics/Camera.h"
#include "../Graphics/Image.h"

#include <cstdio>
#include <cstring>
#include <map>
#include <sstream>

namespace UI
{
// this defines the coordinates to map the texture image from in pairs
const float OtherUVs[8] = {
    0.0f, 0.128f, 0.0f, 0.25f, 1.0f, 0.25f, 1.0f, 0.128f}; // trim the right rounded edge
const float StatBarUVs[8] =                                // stats.png
    {0.0f, 0.0f, 0.0f, 0.125f, 1.0f, 0.125f, 1.0f, 0.0f};
}

std::string itoa(int n)
{
    std::ostringstream s;
    s << n;
    return s.str();
}

using namespace Gfx;

Stats::Stats()
{
    mNet = 100000;
    mPopulation = 0;
    mStars = 1;
    mstrDayOfWeek = "Monday";
    mstrDate = "1-1-2010";

    ImageManager* images = ImageManager::GetInstance();
    Texture* pTex = images->GetTexture("Stats.png", GL_RGBA);
    mOtherFace = new AnimationSingle(pTex, 256, 16);
    mStatsFace = new AnimationSingle(pTex, 256, 16);

    mOtherFace->SetUVs(UI::OtherUVs);
    mStatsFace->SetUVs(UI::StatBarUVs);
    PosCalc();
}

Stats::~Stats() {}

void Stats::PosCalc()
{
    Camera::GetInstance();
    mOtherFace->SetPosition((Camera::GetInstance()->GetCamSize().x / 2) - 128, 0); // relative based on clock
    mStatsFace->SetPosition((Camera::GetInstance()->GetCamSize().x / 2) - 128,
                            -15); // relative based on clock
}

void Stats::Update()
{
    mstrNet = itoa(mNet);
    mstrPopulation = itoa(mPopulation);
}

void Stats::Draw()
{
    Render(mOtherFace);
    Render(mStatsFace);
    float x = mStatsFace->GetPositionX();
    float y = mStatsFace->GetPositionY() + 2;
    RenderText(mStatsFace, x + 40, y, mstrNet);
    RenderText(mStatsFace, x + 158, y, mstrPopulation);
    x = mOtherFace->GetPositionX();
    y = mOtherFace->GetPositionY();
    RenderText(mStatsFace, x + 30, y, mstrDayOfWeek);
    RenderText(mStatsFace, x + 158, y, mstrDate);
}
