using System;
using System.Collections;
using UnityEngine;

//this script helps you to implement the exit functionallity of your screen saver
//the screen saver should be exited when you press any key or move the mouse and this script does this
class ScreenSaverControls : MonoBehaviour
{
    public string settingsScene="settings";
    public float waitingTime = 0; //screen saver will wait this amount (in seconds) before respond to keyboard and mouse events for exiting.
    public int mouseMoveMinDelta = 10; //if the mouse movement's delta is more than this so we will consider it a mouse move event.
    public bool exitWithMouseMove = true; //check if we want to quit the screen saver with mouse move
    public bool exitWithMouseButtons = true; //should we exit with mouse button clicks
    public bool exitWithKeyboard = true; //should we exit with keyboard button clicks
    public bool exitWithEscape = true; //we use this if keyboard is disabled so we can exit with esc only

    private Vector3 movementDelta; //mouse's movement delta. we will calculate it each frame
    private Vector3 mousePosInLastFrame; //we use this to hold the mouse position of each frame to compare it
    private bool respond = false;

    IEnumerator Start()
    {
        //check if we have /c as an argument, load the settings scene
        //the first 0th arg is the name of the application
        if (Environment.GetCommandLineArgs().Length > 1)
        {
            if (Environment.GetCommandLineArgs()[1] == "/c")
            {
                Application.LoadLevel(settingsScene);
            }
        }
        //store the mouse position of the first frame before update to allow us to get the mouse movement delta
        mousePosInLastFrame = Input.mousePosition;
        //you could also use the Invoke method to run a method after <waitingTime> seconds to make the variable true
        yield return new WaitForSeconds(waitingTime);
        respond = true;
    }

    void Update()
    {
        if (respond == true) //we are allowed to check the input for exiting
        {
            if (Input.anyKeyDown) //user pressed a key or mouse button so quit the screen saver
            {
                if (Input.GetMouseButtonDown(0) || Input.GetMouseButtonDown(1) || Input.GetMouseButtonDown(2)) //if we have any mouse key down
                {
                    if (exitWithMouseButtons == true)
                    {
                        Application.Quit();
                    }
                }
                else //user did not press any mouse button so it's a keyboard only event
                {
                    if (exitWithKeyboard == true || (exitWithEscape == true && Input.GetKeyDown(KeyCode.Escape)))
                    {
                        Application.Quit();
                    }
                }
            }
            //check if we should exit with mouse move and if not return because the remaining code is just about that
            if (!exitWithMouseMove) return;
            movementDelta = Input.mousePosition - mousePosInLastFrame; //calculate the movement delta of the mouse. you could use Input.GetAxis("Mouse X") and Input.GetAxis ("Mouse Y") but i wanted to teach you how to calculate this
            if (Mathf.Max(movementDelta.x, movementDelta.y) > mouseMoveMinDelta) //mouse moved enough to consider it a mouse move
            {
                Application.Quit();
            }
            //you could write
            //if(Mathf.Max (Input.GetAxis("Mouse X"),Input.GetAxis("Mouse Y")) > mouseMoveMinDelta)
            //{
            //Application.Quit();
            //}
        }
    }
}