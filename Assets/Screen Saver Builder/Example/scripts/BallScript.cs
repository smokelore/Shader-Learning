using UnityEngine;
using System.Collections;

public class BallScript : MonoBehaviour
{
    public float sec=2; //the animation time
    
    private Color first;
    private Color second;
    void Start()
    {
        SetColor(out first);
        SetColor(out second);
        GetComponent<Renderer>().material.color = first;
        iTween.ScaleTo(this.gameObject, Vector3.one * 2, sec);
        iTween.ColorTo(this.gameObject,second, sec);
        Invoke("Kill",sec+0.2f);
    }

    void Update()
    {
        transform.Translate(Random.Range(-1,1)*Time.deltaTime,4*Random.value*Time.deltaTime,Random.Range(-0.5f,0.5f)*Time.deltaTime);
    }

    void SetColor(out Color c)
    {
        int r = Random.Range(0, 5);
        switch (r)
        {
            case 0:
                c = Color.magenta;
                break;
            case 1:
                c = Color.yellow;
                break;
            case 2:
                c = Color.blue;
                break;
            case 3 :
                c = Color.cyan;
                break;
            case 4:
                c = Color.red;
                break;
            case 5:
                c = Color.green;
                break;
            default:
                c=Color.black;
                break;
        }
    }

    void Kill()
    {
        iTween.Stop(this.gameObject);
        Destroy(this.gameObject);
    }

}

