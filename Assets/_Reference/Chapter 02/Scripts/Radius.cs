using UnityEngine;

[ExecuteInEditMode]
public class Radius : MonoBehaviour 
{
    public Material radiusMaterial;
    public float radius = 1;
    public Color color = Color.white;	

	void Update () 
	{
        radiusMaterial.SetVector("_Center", transform.position);
        radiusMaterial.SetFloat("_Radius", radius);
        radiusMaterial.SetColor("_RadiusColor", color);
    }
}
