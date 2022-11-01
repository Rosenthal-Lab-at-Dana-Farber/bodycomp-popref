#name: lms_curves
#author: Camden Bay - original author. Michael Rosenthal and Andrew Noble - modifications for deployment.
#date: 08-01-2022
#purpose: estimate BC z-scores for CT scan given a corresponding table of demographic data and BC areas

# LICENSE: This code is provided under AGPLv3.

# Note on the use of self-reported race in this data: Self-identified race captures a complex mixture of social
#    determinants of health that include socioeconomic status, historical disparities, inequitable access to care,
#    cultural patterns, and persistent structural inequities. Race-specific data are provided here to support
#    scientific understanding of these groups as they exist today, but great care should be taken to ensure that
#    race-specific metrics are not used in a way that reinforces historical disparities. Please see the following
#    article for additional discussion on this topic:
#
#    Vyas, D. A., Eisenstein, L. G., & Jones, D. S. (2020). Hidden in Plain Sight — Reconsidering the Use of Race
#    Correction in Clinical Algorithms. New England Journal of Medicine, 383(9), 874-882.
#    https://doi.org/10.1056/nejmms2004740


#############################################################################################
#INSTALL REQUIRED PACKAGES ##################################################################
#############################################################################################

library(gamlss)
library(tidyverse)


#############################################################################################
#DEFINE I/O DIR PATHS AND SET WORKING DIR PATH ##############################################
#############################################################################################
INPUT_DIR = "./input"
OUTPUT_DIR = "./output"

#############################################################################################
#LOAD INPUTS ################################################################################
#############################################################################################
# The input table is expected to have the following columns:
# study_name: unique identifier for each exam
# ma, sa, va: muscle area, subcutaneous fat area, and visceral fat area, all in cm2
# age: in years at time of measurement
# sex: {'M' or 'F'}. Insufficient data available for nonbinary and other gender identities
# race: 'W' equals nonhispanic white/ caucasian. 'B' equals black. 'O' includes all other racial groupings and will not
#    return results until additional reference populations are analyzed.

df = read_csv(file.path(INPUT_DIR, 'zscore_input.csv'))
df_1 = df %>% select(study_name, ma, sa, va, age, sex, race)

load('perm_body_comp_lms_functions_no_phi.Rdata')

#############################################################################################
#DEFINE FUNCTION TO ESTIMATE Z-SCORES FROM INPUTS ###########################################
#############################################################################################

z_scores = function(age, sex, race, ma, sa, va) {
    # return NA if age, sex, or race is NaN or NA
    if (anyNA(c(age, sex, race))) return(rep(NA, 3))
    # return NA if age is < 20 or > 90; 
    # this enforces the requirement that, for white females and males, ages > 90 years or < 20 years are out-of-bounds
    if (age < 20. || age > 90.) return(rep(NA, 3))
    # return NA if sex is not in c('F', 'M')
    if (!is.element(sex, c('F', 'M'))) return(rep(NA, 3))
    # return NA if race is not in c('W', 'B')
    if (!is.element(race, c('W', 'B'))) return(rep(NA, 3))
    # return NA for black females with age > 75 years 
    if (sex == 'F' && race == 'B' && age > 75) return(rep(NA, 3))
    # return NA for black males with age > 70 years 
    if (sex == 'M' && race == 'B' && age > 70) return(rep(NA, 3))
    # handle black female case
    if (sex == 'F' && race =='B')
        return(c(z.scores(lms_black_female_ma,  x=age, y=ma), 
                 z.scores(lms_black_female_sa,  x=age, y=sa), 
                 z.scores(lms_black_female_va,  x=age, y=va)))
    # handle black male case
    if (sex == 'M' && race =='B')
        return(c(z.scores(lms_black_male_ma,  x=age, y=ma), 
                 z.scores(lms_black_male_sa,  x=age, y=sa), 
                 z.scores(lms_black_male_va,  x=age, y=va)))
    # handle white female case
    if (sex == 'F' && race =='W')
        return(c(z.scores(lms_white_female_ma,  x=age, y=ma), 
                 z.scores(lms_white_female_sa,  x=age, y=sa), 
                 z.scores(lms_white_female_va,  x=age, y=va)))
    # handle white male case
    if (sex == 'M' && race =='W')
        return(c(z.scores(lms_white_male_ma,  x=age, y=ma), 
                 z.scores(lms_white_male_sa,  x=age, y=sa), 
                 z.scores(lms_white_male_va,  x=age, y=va)))
}

#############################################################################################
#ESTIMATE Z-SCORES FROM INPUT DATAFRAME #############################################
#############################################################################################

list_z_scores = pmap(df_1 %>% select(-study_name), z_scores)
df_z_scores = as_tibble(t(as.data.frame(list_z_scores)))
colnames(df_z_scores) = c('ma_z_score', 'sa_z_score', 'va_z_score')
df_2 = df_1 %>% bind_cols(df_z_scores)

#############################################################################################
#WRITE Z-SCORE OUTPUT #######################################################################
#############################################################################################

write_csv(df_2, file.path(OUTPUT_DIR, "zscores_output.csv"), na = "")
