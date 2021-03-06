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

#ifndef _SECURITY_H
#define _SECURITY_H

#include "../Graphics/ModelObject.h"
#include "FloorBase.h"

#include <map>

class Animation;
class SerializerBase;

enum Security_State { SE_Unoccupied, SE_Occupied };

class Security : public FloorBase, public Gfx::ModelObject
{
    std::map<Security_State, AnimationBase*> manimations;
    Security_State mCurrentState; // vacant /occupied
    int mCurrentAnimation;
    int mPeopleInSecurity;
    int mEmployees;
    int mMaxPositions;
    int mSecurityStyle; // Securitys, boardrooms, data centers, phone banks, etc
    int mSecurityNumner;

public:
    Security(int x, int level, Tower* TowerParent);
    static BaseType GetBaseType() { return BaseSecurity; }
    std::string GetTypeName() const override { return "security"; }

    void Update(float dt, int tod);
    void Draw();
    void DrawFramework();
    virtual BaseType GetType() { return BaseSecurity; }

    void RemoveImages();
    void SetImages(int set);
    void Save(SerializerBase& ser);

    void PeopleInOut(int count);
    bool PeopleApply(); // get a job
    void SetSecurityNumber(int no) { mSecurityNumner = no; }
    int GetSecurityNumber() { return mSecurityNumner; }

private:
    void SecurityState(int tod);
};

#endif // _SECURITY_H
