using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class GenerateMesh : MonoBehaviour {

	// Use this for initialization
	void Start () {
		Mesh mesh = GetComponent<MeshFilter> ().mesh;
		Vector3[] vertices = new Vector3[6];
		vertices [0] = new Vector3 (0,0,0);
		vertices [1] = new Vector3 (1,0,0);

		vertices [2] = new Vector3 (0,0,1);
		vertices [3] = new Vector3 (1,0,1);

		vertices [4] = new Vector3 (0,0.5f,1.5f);
		vertices [5] = new Vector3 (1,0.5f,1.5f);
		mesh.vertices = vertices;

		int[] triangles = new int[12];
		triangles[0] = 0;
		triangles[1] = 2;
		triangles[2] = 1;

		triangles[3] = 2;
		triangles[4] = 3;
		triangles[5] = 1;

		triangles[6] = 2;
		triangles[7] = 4;
		triangles[8] = 3;

		triangles[9] = 4;
		triangles[10] = 5;
		triangles[11] = 3;

		mesh.triangles = triangles;

		Vector3[] normals = new Vector3[6];
		normals [0] = -Vector3.forward;
		normals [1] = -Vector3.forward;
		normals [2] = -Vector3.forward;
		normals [3] = -Vector3.forward;
		normals [4] = -Vector3.forward;
		normals [5] = -Vector3.forward;
		mesh.normals = normals;

		Vector2[] uv = new Vector2[6];

		uv[0] = new Vector2(0, 0);
		uv[1] = new Vector2(1, 0);
		uv[2] = new Vector2(0, 0.5f);
		uv[3] = new Vector2(1, 0.5f);
		uv[4] = new Vector2(0, 1);
		uv[5] = new Vector2(1, 1);

		mesh.uv = uv;
		mesh.RecalculateBounds ();
		mesh.RecalculateNormals ();

	}
	
	// Update is called once per frame
	void Update () {
		

	}
}
