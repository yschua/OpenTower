/*This file is part of Highrise Developer.
 *
 *Highrise Developer is free software: you can redistribute it and/or modify
 *it under the terms of the GNU General Public License as published by
 *the Free Software Foundation, either version 3 of the License, or
 *(at your option) any later version.

 *Highrise Developer is distributed in the hope that it will be useful,
 *but WITHOUT ANY WARRANTY; without even the implied warranty of
 *MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *GNU General Public License for more details.
 *
 *You should have received a copy of the GNU General Public License
 *along with Highrise Developer.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "Camera.h"

#include "../AI/CitizensAgent.h"
#include "../Resources.h"
#include "../Root/Physics.h"
#include "../Scene/Scene.h"
#include "Animation.h"
#include "Image.h"
#include "ModelObject.h" // 3d abstract
#include "ViewObject.h"  // 2d abstract

#include <SFML/Graphics.hpp>
#include <SFML/System.hpp>
#include <cstring>
#include <gl/GLU.h>
#include <iostream>

#define FIELD_OF_VIEW 90.0f // this controls how long the focal view of the camera is in OpenGL

Camera::Camera() : Body(1280, 720), mBounds(-1600, -1280, 1700, 1340)
{
    sf::ContextSettings Settings;
    Settings.depthBits = 24;        // Request a 24 bits depth buffer
    Settings.stencilBits = 8;       // Request a 8 bits stencil buffer
    Settings.antialiasingLevel = 2; // Request 2 levels of antialiasing
    mpWindow = new sf::RenderWindow();
    mpWindow->create(sf::VideoMode(800, 600, 32),
                     "Highrise Developer (version " HR_VERSION ")",
                     sf::Style::Close | sf::Style::Resize,
                     Settings);
    // mpWindow->SetPosition( 0, 100);
    mZoomFactor = -400; // back away 200 feet
    mAspect = (float)(800.0 / 600);
    mCam.x = 800;
    mCam.y = 600;
    mIgnoreCamera = false;
    ms.x = -820;
    ms.y = -160;
    mpWindow->setMouseCursorVisible(false);
}

Vector2i Camera::GetMouse()
{
    Vector2f ms2(ms.x, ms.y);
    return ms2 + GetLocalMouse();
}

Vector2i Camera::GetLocalMouse()
{
    return sf::Mouse::getPosition(*mpWindow);
}

void Camera::SetMaxFramerate(int rate)
{
    mpWindow->setFramerateLimit(rate);
}

void Camera::SetSceneSize(Vector2f Size)
{
    glClearDepth(1.0f);
    mScene.x = Size.x;
    mScene.y = Size.y;
}

Camera* Camera::GetInstance()
{
    static Camera camera;
    return &camera;
}

void

// modes functions
Camera::Clear()
{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

void Camera::SetActive()
{
    glViewport(0, 0, (GLsizei)mCam.x, (GLsizei)mCam.y);
    glEnable(GL_TEXTURE_2D);
    //   mpWindow->SetActive (true);
}

void Camera::Display()
{
    // For fun ;)
    // int BounceAmount = 2;
    // Do bounds checking
    const float right = mBounds.left + mBounds.width;
    if (ms.x > right) // 0
    {
        ms.x = right;
        // Outside of left bound
        if (mv.x > 0)
            mv.x = 0;
        mv.x = -1; //+= -20;
        ma.x = 1;  // 10;
    }
    if (ms.x < mBounds.left) //-1280
    {
        ms.x = mBounds.left;
        // Outside of right bound
        if (mv.x < 0)
            mv.x = 0;
        mv.x = 1;  // += 20;
        ma.x = -1; // -10;
    }
    const float bottom = mBounds.top + mBounds.height;
    if (ms.y > bottom) // 400
    {
        ms.y = bottom; // 400
        // Outside of bottom bound
        if (mv.y > 0)
            mv.y = 0;
        mv.y = -1; //+= -20;
        ma.y = 1;  // 10;
    }
    if (ms.y < mBounds.top) // -675
    {
        ms.y = mBounds.top; //-675
        // Outside of top bound
        if (mv.y < 0)
            mv.y = 0;
        mv.y = 1;  //+= 20;
        ma.y = -1; //-10;
    }

    mpWindow->display();
}

void Camera::Center(int x, int y)
{
    ms.x = -550; // x - (mViewRect.Left / 2);
    ms.y = -200; // y - (mViewRect.Top / 2);
}

bool Camera::OnResize(Vector2i vi)
{
    glViewport(0, 0, vi.x, vi.y);
    mCam = vi;
    mAspect = (float)(vi.x) / vi.y;
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(FIELD_OF_VIEW, mAspect, 1.0f, 1000.0f); // Calculate The Aspect Ratio Of The Window
    return true;
}

void Camera::InitGL()
{
    glShadeModel(GL_SMOOTH); // Enable Smooth Shading
    glClearDepth(1.0f);      // Depth Buffer Setup
    glClearColor(0.f, 0.f, 0.f, 0.f);
    glDepthFunc(GL_LEQUAL);                            // The Type Of Depth Testing To Do
    glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST); // Really Nice Perspective Calculations
    glEnable(GL_TEXTURE_2D);

    // Enable Z-buffer read and write
    glEnable(GL_DEPTH_TEST);
    glDepthMask(GL_TRUE);

    // Setup a perspective projection
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(FIELD_OF_VIEW, mAspect, 1.0f, 1000.f);
    glEnable(GL_TEXTURE_2D);
}

void Camera::DrawModel(Scene* pModel) // 3d interface objects
{
    //   glDisable (GL_LIGHTING);
    glMatrixMode(GL_MODELVIEW);
    glPushMatrix();
    { // brackets just keep the code in push and pop uniform
        glEnable(GL_TEXTURE_2D);
        glTranslatef(GetPositionX(), GetPositionY(), mZoomFactor);
        glColor4ub(255, 255, 255, 255);
        glEnable(GL_BLEND);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

        pModel->Draw();
        glDisable(GL_BLEND);
    }
    glPopMatrix();
}

void Camera::DrawPeople(CitizensAgent* pPeople) // 3d interface objects
{
    //   glDisable (GL_LIGHTING);
    glMatrixMode(GL_MODELVIEW);
    glPushMatrix();
    { // brackets just keep the code in push and pop uniform
        glEnable(GL_TEXTURE_2D);
        glTranslatef(GetPositionX(), GetPositionY() - 18, mZoomFactor);
        glColor4ub(255, 255, 255, 255);
        glEnable(GL_BLEND);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

        pPeople->Draw();
        glDisable(GL_BLEND);
    }
    glPopMatrix();
}

void Camera::DrawInterface(Interface* pI) // 2d interface objects
{
    glMatrixMode(GL_MODELVIEW);
    glPushMatrix();
    glLoadIdentity();
    glEnable(GL_TEXTURE_2D);
    glTranslatef((GLfloat)(-0.3125 * mWidth.x), (GLfloat)(mHeight.y / 2 - 144), -380);
    //      glTranslatef (GetPositionX(), GetPositionY(), mZoomFactor);
    glColor4ub(255, 255, 255, 255);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    pI->Draw();
    glDisable(GL_BLEND);
    glPopMatrix();
}

#define BUFFER_LENGTH 64 // max click hits we expect but we might get 2
int Camera::TranslateX(Scene* pModel, Vector2f mouse)
{
    return (int)(mouse.x * mAspect / 9) - 34; // still has an error
}

int Camera::RenderFramework(Scene* pModel, Vector2f mouse, int level)
{
    int iResult = 0;

    glPushAttrib(GL_ALL_ATTRIB_BITS);

    glDisable(GL_LIGHTING);
    // Space for selection buffer
    GLuint selectBuff[BUFFER_LENGTH];

    // Hit counter and viewport storeage
    GLint hits, viewport[4];

    // Setup selection buffer
    glSelectBuffer(BUFFER_LENGTH, selectBuff);

    // Get the viewport
    glGetIntegerv(GL_VIEWPORT, viewport);

    // Switch to projection and save the matrix
    glMatrixMode(GL_PROJECTION);
    glPushMatrix();

    // Change render mode
    glRenderMode(GL_SELECT);

    // Establish new clipping volume to be unit cube around
    // mouse cursor point (xPos, yPos) and extending two pixels
    // in the vertical and horzontal direction
    glLoadIdentity();
    glInitNames();
    glPushName(0);

    gluPickMatrix(mouse.x, viewport[3] - mouse.y, 2, 2, viewport); // mouse y is inverted

    // Apply perspective matrix
    gluPerspective(FIELD_OF_VIEW, mAspect, 1.0f, 1000.f); // Calculate The Aspect Ratio Of The Window
    glTranslatef(GetPositionX(), GetPositionY(), mZoomFactor);

    // Draw the scene
    pModel->RenderFramework(
        level); // is level is not Zero then we run a render check on that level else we do the whole tower

    // Collect the hits
    hits = glRenderMode(GL_RENDER);

    // Restore the projection matrix
    glMatrixMode(GL_PROJECTION);
    glPopMatrix();

    // Go back to modelview for normal rendering
    glMatrixMode(GL_MODELVIEW);

    // If a single hit occured, display the info.
    GLuint nHit = -1;
    if (hits == 1) {
        //      MakeSelection(selectBuff[3]);
        if (nHit != selectBuff[3]) {
            iResult = selectBuff[3]; // ok what did we hit
        }
    }
    glPopAttrib();
    return iResult; // the object id
}

Vector3f Camera::GetOGLPos(Vector2f winVec) // NeHe Productions at GameDev
{
    // this little magic function takes the mouse position in view coordinates and transforms it through
    // the same GL Matrix as the scene. This is then adjusted for the building positon.
    GLint viewport[4];
    GLdouble modelview[16];
    GLdouble projection[16];

    glMatrixMode(GL_MODELVIEW);
    glPushMatrix();

    glGetDoublev(GL_MODELVIEW_MATRIX, modelview);
    glGetDoublev(GL_PROJECTION_MATRIX, projection);
    glGetIntegerv(GL_VIEWPORT, viewport);

    GLfloat winX = winVec.x;
    GLfloat winY = winVec.y; //(float)viewport[3] - winVec.y;
    GLfloat winZ;

    glReadPixels((int)winX, int(winY), 1, 1, GL_DEPTH_COMPONENT, GL_FLOAT, &winZ);

    GLdouble posX = 0;
    GLdouble posY = 0;
    GLdouble posZ = 0;
    gluUnProject(winX, winY, winZ, modelview, projection, viewport, &posX, &posY, &posZ);

    glMatrixMode(GL_MODELVIEW);
    glPopMatrix();
    return Vector3f(
        (float)posX - GetPositionX(), (float)posY + GetPositionY(), (float)posZ); // +GetPositionX());
}

bool Camera::GetEvent(sf::Event& event)
{
    return mpWindow->pollEvent(event);
}

bool Camera::OnKeyDown(sf::Keyboard::Key Key)
{
    return false;
}

void Camera::MoveCamera()
{
    if (!mpWindow->hasFocus()) return;

    mv.x = mv.y = 0.f;

    if (sf::Keyboard::isKeyPressed(sf::Keyboard::D)) {
        mv.x += mZoomFactor;
    }
    if (sf::Keyboard::isKeyPressed(sf::Keyboard::S)) {
        mv.y += -1.f * mZoomFactor;
    }
    if (sf::Keyboard::isKeyPressed(sf::Keyboard::A)) {
        mv.x += -1.f * mZoomFactor;
    }
    if (sf::Keyboard::isKeyPressed(sf::Keyboard::W)) {
        mv.y += mZoomFactor;
    }
}

bool Camera::OnMouseWheel(int Delta)
{
    if (Delta > 0)
        ZoomIn();
    else
        ZoomOut();
    return true;
}

void Camera::ZoomIn()
{
    Zoom(10);
}
void Camera::ZoomOut()
{
    Zoom(-10);
}

void Camera::Zoom(float Factor)
{
    // Rectf ZoomedRect;
    // Calcuate the center
    if ((Factor < 0 && mZoomFactor > -900) || (Factor > 0 && mZoomFactor < -40)) {
        mZoomFactor += Factor;
    }
    //std::cout << "ZF=" << mZoomFactor << "\n";
}
