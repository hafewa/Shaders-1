using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PersonMove : MonoBehaviour {

	Vector4 v = new Vector4();
	public Material m;
	// Use this for initialization
	void Start () {
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetKey (KeyCode.W)) {
			transform.position += transform.forward * 0.05f;
		}
		if (Input.GetKey (KeyCode.A)) {
			transform.Rotate (0,2,0);
		}else if (Input.GetKey (KeyCode.D)) {
			transform.Rotate (0,-2,0);
		}
		Vector3 v1 = transform.position;
		v.Set (v1.x, v1.y, v1.z, 0f);
		Debug.Log (v);
		m.SetVector ("_PersonPos",v);
	}
}
