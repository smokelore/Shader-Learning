using System.Collections;
using UnityEngine;

[ExecuteInEditMode] // makes the Screen Effect editable within the Editor without entering Play mode.
public class Ch8BlendModeImageEffect : MonoBehaviour
{
    #region Variables
    public Shader curShader;

    public Texture2D blendTexture;

    [Range(0.0f, 1.0f)]
    public float blendOpacity = 1.0f;

    private Material curMaterial;
    #endregion

    #region Properties
    Material material
    {
        // material getter checks for a material, creates one if it doesn't find one.
        get
        {
            if (curMaterial == null)
            {
                curMaterial = new Material(curShader);
                curMaterial.hideFlags = HideFlags.HideAndDontSave;
            }

            return curMaterial;
        }
    }
    #endregion

    private void Start()
    {
        // check that the target platform supports image effects.
        if (!SystemInfo.supportsImageEffects)
        {
            enabled = false;
            return;
        }

        // script disables itself if image effects aren't supported.
        if (curShader && !curShader.isSupported)
        {
            enabled = false;
        }
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        // access the render texture from the Unity Renderer.
        if (curShader != null)
        {
            material.SetTexture("_BlendTex", blendTexture);
            material.SetFloat("_BlendOpacity", blendOpacity);

            Graphics.Blit(source, destination, material);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }

    private void Update()
    {
        blendOpacity = Mathf.Clamp01(blendOpacity);
    }

    private void OnDisable()
    {
        // clean up the curMaterial object we created in the material getter if this script is disabled.
        if (curMaterial)
        {
            DestroyImmediate(curMaterial);
        }
    }
}
