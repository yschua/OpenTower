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

#ifndef _FLOORAGENT_H
#define _FLOORAGENT_H

class Tower;
class FloorSpace;
class FloorBase;

class FloorAgent
{
protected:
    Tower& mTower;

public:
    FloorAgent(Tower& tower);
    ~FloorAgent();

    FloorBase* FindWork(int preferences);
    FloorBase* FindAHome(int preferences);
    FloorBase* FindAHotel(int preferences);
};

#endif
