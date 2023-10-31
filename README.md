# Sensors_Control_DoBotSorting
## 41014 Sensors and Control for Mechatronic Systems - UTS

Group members:
- Laurentius Setiadharma (14018295)
- Rio Setyo (14089371)
- Marcus Yam (24441988)

## Project Description
Our project integrates the Intel Real Sense D435i RGBD Camera with the DoBot Magician Robot to execute a color-sorting task. The primary objective is to identify, categorize by colour, and subsequently pick up and sort objects, in this case, boxes.

## Workflow
1.** Object Recognition:** Using the camera, the system first detects the boxes on the platform.

2. **Color Filtering: **Once the boxes are identified, the system categorizes them based on their colour.

3. **Centroid Calculation:** After the desired colour is detected, the system determines the object's centroid. This central point serves as a reference for the next stages.

4. **Depth Sensing:** Utilizing the centroid of the box, the system then maps the depth value from the depth image.

5. **Pixel to 3D Coordinate Conversion:** With the depth value and centroid, the system processes this data to derive the 3D coordinates of the box.

6. **Frame of Reference Transformation:** Before sending the data to the robot, the system adjusts the 3D coordinates to align with the robot's frame of reference. This step ensures that the robot interacts accurately with the boxes.

7. **Robot Control:** Finally, with all the required data, the DoBot Magician Robot picks up the box and sorts it based on its colour.

