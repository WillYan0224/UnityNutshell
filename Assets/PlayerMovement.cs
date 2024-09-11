using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    public float speed = 5.0f;  // Movement speed
    public float rotationSpeed = 100.0f; // Rotation speed
    void Update()
    {
        // Get input from WASD keys or arrow keys
        float moveHorizontal = Input.GetAxis("Horizontal");
        float moveVertical = Input.GetAxis("Vertical");

        // Calculate movement vector
        Vector3 movement = new Vector3(moveHorizontal, 0.0f, moveVertical);

        // Apply movement to the player
        transform.Translate(movement * speed * Time.deltaTime, Space.World);

        float rotation = 0.0f;
        if (Input.GetKey(KeyCode.Q))
        {
            rotation = -rotationSpeed * Time.deltaTime;
        }
        else if (Input.GetKey(KeyCode.E))
        {
            rotation = rotationSpeed * Time.deltaTime;
        }

        // Apply rotation to the player
        transform.Rotate(0, rotation, 0);

    }
}