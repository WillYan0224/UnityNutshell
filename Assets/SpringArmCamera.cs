using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class SpringArmCamera : MonoBehaviour
{
    public Transform target;          // The target the camera will follow
    public float distance = 5.0f;     // Distance from the target
    public float height = 2.0f;       // Height above the target
    public float damping = 5.0f;      // Damping effect for smooth movement
    public float rotationSpeed = 100.0f; // Speed of camera rotation around the target

    [SerializeField] float radius = 0.5f; // Radius of the sphere collider

    private Vector3 currentVelocity;  // Velocity used by SmoothDamp

    void LateUpdate()
    {
        if (!target) return;

        // Calculate the desired position
        Vector3 desiredPosition = target.position - target.forward * distance + Vector3.up * height;

        // Smoothly move the camera to the desired position
        transform.position = Vector3.SmoothDamp(transform.position, desiredPosition, ref currentVelocity, damping * Time.deltaTime);

        // Rotate the camera based on user input (optional)
        float horizontalInput = Input.GetAxis("Mouse X") * rotationSpeed * Time.deltaTime;
        transform.RotateAround(target.position, Vector3.up, horizontalInput);

        // Always look at the target
        transform.LookAt(target);
    }

    private void OnDrawGizmos()
    {
        Gizmos.DrawWireSphere(transform.position, radius);
    }
}