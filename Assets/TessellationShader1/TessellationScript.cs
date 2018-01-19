using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TessellationScript : MonoBehaviour {

	ComputeBuffer buffer;
	public Material mat;

	// Use this for initialization
	void Start () {
		Vector3[] quad = new Vector3[4];
		quad [0] = new Vector3 (-100,-100,0);
		quad [1] = new Vector3 (-100,100,0);
		quad [2] = new Vector3 (100,100,0);
		quad [3] = new Vector3 (100,-100,0);
		buffer = new ComputeBuffer (quad.Length, 16,ComputeBufferType.Default);
		buffer.SetData (quad);
		mat.SetBuffer ("buffer", buffer);
	}

	void OnRenderObject(){
		mat.SetPass (0);
		Graphics.DrawProcedural (MeshTopology.Quads, buffer.count, 1);
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
