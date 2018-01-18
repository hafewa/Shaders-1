using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class TerrainScript : MonoBehaviour {

	//terrain variables
	[Range(1.0f,100.0f)]
	public float passo = 1.0f;
	public bool wireframe = true;
	public int width = 100;
	public int heigth = 100;
	public int maxHeigth = 200;
	public float resolution = 1000;
	public Texture2D heightMap;
	public Material m;

	ComputeBuffer buffer;
	float posx=0f,posy=0f;
	data[] triangles;
	data[,] vertices;
	int[] index;

	struct data {
		public Vector3 pos;
		public Vector3 normal;
	};

	// Use this for initialization
	void Start () {
		int i;
		int j;
		vertices = new data[width,heigth];
		triangles = new data[(width-1)*(heigth-1)*2];
		index = new int[((width-1)*(heigth-1)*6)];

		for (i=0;i<width;i++){
			posy = 0f;
			for (j = 0; j < heigth; j++) {
				vertices [i,j].pos = new Vector3 (posx, 0.0f, posy);
				vertices [i, j].pos.y = maxHeigth*GetHeight (i,j)/passo;//maxHeigth*Mathf.PerlinNoise (posx/resolution,posy/resolution);//(float)Random.Range (0, maxHeigth);
				posy+=passo;
			}
			posx+=passo;
		}
		triangles = Triangulate (vertices);
		CalculateNormals (triangles);
		buffer = new ComputeBuffer (triangles.Length, 12,ComputeBufferType.Default);
		buffer.SetData (triangles);
		m.SetBuffer ("buffer", buffer);
	}

	float GetHeight(int i, int j){
		Color h = heightMap.GetPixel (i,j);
		return h.r;
	}

	void OnRenderObject(){
		m.SetPass (0);
		if (wireframe == true) {
			Graphics.DrawProcedural (MeshTopology.Lines, buffer.count, 1);
		} else {
			Graphics.DrawProcedural (MeshTopology.Triangles, buffer.count, 1);
		}
	}

	data[] Triangulate(data[,] points){
		data[] pointsOut = new data[((width-1)*(heigth-1)*6)];
		int i, j;
		int count = -1;
		for (i = 0; i < width-1; i++) {
			for (j = 0; j < heigth-1; j++) {
				pointsOut[++count] = points[i,j];
				pointsOut[++count] = points[i,j+1];
				pointsOut[++count] = points[i+1,j];

				pointsOut[++count] = points[i,j+1];
				pointsOut[++count] = points[i+1,j+1];
				pointsOut[++count] = points[i+1,j];
			}
		}
		return pointsOut;
	}

	void CalculateNormals(data[] vertices){
		for(int i=0;i<vertices.Length;i+=3){
			Vector3 normal = CalcNormal (vertices[i].pos,vertices[i+1].pos,vertices[i+2].pos);
			vertices [i].normal = normal;
			vertices[i+1].normal = normal;
			vertices[i+2].normal = normal;
		}
	}

	Vector3 CalcNormal(Vector3 v1, Vector3 v2, Vector3 v3){
		Vector3 dir = Vector3.Cross(v2 - v1, v3 - v1);
		Vector3 norm = Vector3.Normalize(dir);
		return norm;
	}

	Vector3[] FlatArray(data[,] array){
		Vector3[] vertex = new Vector3[width*heigth];
		for (int i = 0; i < width - 1; i++) {
			for (int j = 0; j < heigth - 1; j++) {
				vertex [i * width + j] = vertices [i, j].pos;
			}
		}
		return vertex;
	}

	void OnDestroy(){
		buffer.Release ();
	}

	// Update is called once per frame
	void Update () {
		
	}
}
