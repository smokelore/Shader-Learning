using System.Collections;
using UnityEngine;


class Creator : MonoBehaviour
{
    public GameObject ball;
    public int count = 3;

    private Vector3 v;
    private int i;
    IEnumerator Start ()
    {
        while (true)
        {
            for (i = 0; i < count; i++)
            {
                v.x = Random.Range(-7f, 7f);
                v.y = Random.Range(-3f, 3f);
                v.z = Random.Range(-5f, 9f);
                Instantiate(ball, v, Quaternion.identity);
                yield return new WaitForSeconds(Random.value / 4f);
            }
            yield return new WaitForSeconds(Random.value);
        }
    }
}