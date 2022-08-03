# bodycomp-popref
Calculate population-indexed normative values for body composition measurements. 

This tool was created by Dr. Camden Bay (biostatistics) and encompasses the CT-based body composition data provided in Magudia et al 2021 (citation below). This tool will accept a list of body composition areas, including skeletal muscle area, subcutaneous fat area, and visceral fat area, plus subject demographics (age at measurement, sex, race) and return population-indexed normative values. These values are currently returned in the form of z-scores.  

Z-scores represent the distance in standard deviation units from the median value for each subject's reference population. A z-score of zero means that the subject is at the median, while a z-score of +1.0 is one standard deviation above the median value. Z-scores offer the advantage that they remove age-, sex-, and race-specific effects from the body composition measurement, at least to the extent that those effects are captured by the reference population. For example, people typically gain subcutaneous fat from their 20's to their 50's and then begin to lose that fat again. The uncorrected raw areas would need to be adjusted for age using a nonlinear technique such as spline fitting or quartile analysis to remove this effect, whereas z-scores do not vary with age, sex, or race so long as the individual stays at their original body percentile and do not need to be adjusted for these factors.  

The reference population within this repository is based on 12,128 subjects who underwent outpatient CT imaging in the Mass General Brigham hospital system in the year 2012. Subjects who had ICD codes for major cardiovascular diseases or cancer (excluding non-melanoma skin cancer) were excluded from the population. The indication for the CT imaging was not otherwise considered to avoid biasing the population away from individuals who undergo CT imaging. 

To cite the source paper for this work, please use the following reference:

Magudia, K., Bridge, C. P., Bay, C. P., Babic, A., Fintelmann, F. J., Troschel, F. M., Miskin, N., Wrobel, W. C., Brais, L. K., Andriole, K. P., Wolpin, B. M., & Rosenthal, M. H. (2021). Population-Scale CT-based Body Composition Analysis of a Large Outpatient Population Using Deep Learning to Derive Age-, Sex-, and Race-specific Reference Curves. Radiology, 298(2), 319-329. https://doi.org/10.1148/radiol.2020201640 


Note on the use of self-reported race in this data: Self-identified race captures a complex mixture of social determinants of health that include socioeconomic status, historical disparities, inequitable access to care, cultural patterns, and persistent structural inequities. Race-specific data are provided here to support scientific understanding of these groups as they exist today, but great care should be taken to ensure that race-specific metrics are not used in a way that reinforces historical disparities. Please see the following article for additional discussion on this topic:

    Vyas, D. A., Eisenstein, L. G., & Jones, D. S. (2020). Hidden in Plain Sight — Reconsidering the Use of Race Correction in Clinical Algorithms. New England Journal of Medicine, 383(9), 874-882. https://doi.org/10.1056/nejmms2004740
