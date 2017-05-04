using System;
using System.Diagnostics;
using System.IO;
using UnityEditor;
using UnityEngine;


class ScreenSaverBuilder
{

    [MenuItem("Tools/Build Screen Saver")]
    static void ScreenSaverWizard()
    {
        bool haveSettings = EditorUtility.DisplayDialog("Settings Dialog", "Does this screen saver have any settings dialog? if yes don't forget to type the settings scene's name in ScreenSaverController component.", "Yes", "No");
        string starterfile;
        if (haveSettings == true)
            starterfile = "starter.scr";
        else
            starterfile = "starterws.scr";
         
        string path = EditorUtility.OpenFilePanel("choose a windows standalone file", Application.dataPath, "exe");
        if (File.Exists(path))
        {
            //this check is not something important. by removing this you can compile none unity projects to screen savers using this tool. we love unity so we put this here
            //don't use it to create screen savers with apps built by other game engines please. it's not a ristriction but we will be happy if you follow this :)
            if (Directory.Exists(Path.GetDirectoryName(path) + @"\" + Path.GetFileNameWithoutExtension(path) + @"_Data\")) //check if it's a unity project by checking the availability of the exename_data folder :)
            {
                if (File.Exists(Application.dataPath + @"\Screen Saver Builder\"+starterfile) == true)
                {
                    if (File.Exists(Path.GetDirectoryName(path) + @"\" + Path.GetFileNameWithoutExtension(path) + ".scr"))
                    {
                        if (EditorUtility.DisplayDialog("file currently exists", "screen saver starter file currently exists in this folder. do you want to replace it", "Yes", "No"))
                        {
                            File.Delete(Path.GetDirectoryName(path) + @"\" + Path.GetFileNameWithoutExtension(path) + ".scr");
                        }
                        else
                        {
                            return;
                        }
                    }
                    File.Copy(Application.dataPath + @"/Screen Saver Builder/"+starterfile, Path.GetDirectoryName(path) + @"\" + Path.GetFileNameWithoutExtension(path) + ".scr");
                    Process p = new Process();
                    p.StartInfo.FileName = Path.GetDirectoryName(path);
                    p.StartInfo.UseShellExecute = true;
                    p.Start();
                }
                else
                {
                    UnityEngine.Debug.LogError("could not find the screen saver player at path " + Application.dataPath + @"\Screen Saver Builder\starter.scr" + " \nImport the screen saver package again and don't change the folder structure of it");
                }
            }
            else
            {
                EditorUtility.DisplayDialog("Error", "this is not a unity windows standalone project!", "Ok");
                UnityEngine.Debug.LogError("the choosen exe file is not a unity standalone exe project");
            }
        }
        else
        {
            UnityEngine.Debug.LogError("the file:" + path + " could not be found!");
        }
    }

}