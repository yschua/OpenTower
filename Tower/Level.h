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

#ifndef _LEVEL_H
#define _LEVEL_H
#include "../Graphics/ModelObject.h"
#include "FloorBase.h"

#include <list>
#include <map>
#include <memory>

class AnimationSingle;
class AnimationEmpty;
class FloorBase;
class Tower;
class RouteBase;
class PersonQueue;
class GameManager;
class FloorAgent;

class Level : public Gfx::ModelObject
{
    friend class GameManager;
    friend class FloorAgent;

public:
    Level(int level, int x, int y, int x2, Tower* TowerParent);
    virtual ~Level();
    static BaseType GetBaseType() { return BaseEmpty; }
    static const char* GetTypeString() { return "level"; }
    bool IsFloorFull() { return mFloorIsFull; }
    bool HasLobby();
    double GetRentCollected() { return mRentCollected; };
    // Level tracking methods/functions
    void ResizeFloorSpaceGrid();
    void ScanFloorSpace();            // Marks the gird for what is in the space
    bool IsSpaceEmpty(int x, int x2); // TestForEmptySpace...
    void DrawEmptySpace();
    void DrawFramework(bool LevelOnly);
    void DrawEmptyFramework();
    // End prototype code
    inline int GetLevel() { return mLevel; }
    inline int GetID() { return mID; }
    inline int GetX() { return mX; }
    virtual void Update(float dt, int tod);
    virtual void Draw();
    bool AddFloorSpace(std::unique_ptr<FloorBase> floor);
    bool RemoveFloorSpace(FloorBase* floor);
    void SetFloorPositions(int x, int x2);
    FloorBase* GetSpaceByID(int id);
    FloorBase* FindSpace(int x); // location
    bool TestForEmptySpace(int x, int x2);
    void Save(SerializerBase& ser);

    static const int mUnitSize;

protected:
    inline std::map<int, std::unique_ptr<FloorBase>>& GetFloorSpaces() { return mFloorSpaces; }

    int mLevel;
    int mX;   // lower left origin.x
    int mX2;  // x vector = width
    int mY;   // lower left origin.y
              // y vector = height
    float mZ; // face set to zero
              // z vector = depth but not implement until 3D
    int mNextRentDay;
    double mRentCollected;
    AnimationSingle* nFireEscapeLeft;
    AnimationSingle* nFireEscapeRight;
    AnimationSingle* mEmptyFLoor;
    AnimationEmpty* mTheLevel;

    // Level open Space tracking grid (proto type stuff
    // Just using allocated simple byte array for easy debugging
    unsigned char* mpFloorSpaceGrid;
    int mFloorSpaceGridSize;
    bool mFloorIsFull;       // Can't place any more objects
    bool mNoEmptyFloorSpace; // Skip the DrawEmptySpace function

private:
    std::map<int, std::unique_ptr<FloorBase>> mFloorSpaces;
    Tower* mTowerParent;
    int mID;
};

#endif
