using UnityEngine;

[ExecuteInEditMode]
public class ShowPhongReflection : MonoBehaviour 
{
	public float length = 1;
	public Vector3 bias;
	public Transform lightSource;	// must be directional light

	// Update is called once per frame
	void Update() 
	{
		Mesh mesh = GetComponent<MeshFilter>().sharedMesh;

		Vector3[] vertices = mesh.vertices;
		Vector3[] normals = mesh.normals;
		Vector3 L = lightSource.eulerAngles;

		for (var i = 0; i < normals.Length; i++)
		{
			Vector3 pos = vertices[i];
			pos.x *= transform.localScale.x;
			pos.y *= transform.localScale.y;
			pos.z *= transform.localScale.z;
			pos += transform.position + bias;

			Vector3 N = normals[i];
			Vector3 R = (2*N) * Vector3.Dot(N, L) - L; 
			R.Normalize();

			Debug.DrawLine(pos, pos + R * length, Color.red);
		}
	}
}