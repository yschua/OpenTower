#pragma once

#include "tinyxml/tinyxml.h"

#include <SFML/Graphics.hpp>
#include <string>
//#include "../Graphics/Graphics.h"
//#include "../Game/String.h"

namespace OT
{
namespace xml
{
bool GetUIElements(TiXmlNode*, std::vector<sf::Drawable*>&);
sf::Color GetColor(TiXmlNode*);
sf::Vector2i GetPointi(TiXmlNode*);
sf::Vector2f GetPoint(TiXmlNode*);
}
}
