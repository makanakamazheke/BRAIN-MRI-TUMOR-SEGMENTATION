# MRI Reconstruction and Segmentation Pipeline (MATLAB)

### 3D Tumour Rotation (Animated)
<img src="IMAGES/tumor_rotation.gif" width="500">


I developed a complete MRI processing pipeline in MATLAB, starting from raw k‑space data to the full 2D and 3D spatial brain MRI images. 
This included 2D inverse Fourier reconstruction of a single slice, circular low‑pass and high‑pass k‑space filtering, 3D inverse FFT of a volumetric head dataset, rotation correction of misaligned slices, intensity‑based tumour segmentation on a single slice and the full 3D volume (Dice coefficient against ground truth), and 3D visualisation of the segmented tumour using volume rendering. 

I learnt the core concepts in MRI image reconstruction, general medical image processing, applied Fourier transforms from my physics courses, and binary segmentation.

## Results

### K-space Visualisation (Log Scale)
<img src="IMAGES/k-space_visualisation.png" width="500">

### Spatial Domain Reconstruction
<img src="IMAGES/spatial.png" width="500">

### Multi-Plane Reconstruction (Sagittal, Coronal, Axial)
<img src="IMAGES/sagittal_coronal_axial.png" width="500">

### Frequency Filtering (Low-pass vs High-pass)
<img src="IMAGES/low_pass_high_pass_filtering.png" width="500">

### Rotation Correction
<img src="IMAGES/Corrected_Rotation.png" width="500">

### Tumour Segmentation (Mask + Overlay)
<img src="IMAGES/mask_overlayed_plot.png" width="500">

### Overlayed MRI Slice
<img src="IMAGES/overlayed_image.png" width="500">

### 3D Tumour Visualisation
<img src="IMAGES/3D_VOLUME_RENDERING_OF_TUMOR.png" width="500">
