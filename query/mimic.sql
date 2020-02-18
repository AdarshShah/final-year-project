
SELECT COUNT(*) FROM mimiciii.icustays
INNER JOIN mimiciii.diagnoses_icd USING(hadm_id)
INNER JOIN mimiciii.d_icd_diagnoses USING(icd9_code);

SELECT COUNT(*) FROM mimiciii.chartevents
INNER JOIN mimiciii.diagnoses_icd USING(hadm_id)
INNER JOIN mimiciii.d_icd_diagnoses USING(icd9_code);

SELECT COUNT(*)
from mimiciii.chartevents
INNER JOIN mimiciii.icustays
USING(hadm_id,icustay_id)
INNER JOIN mimiciii.diagnoses_icd
USING(hadm_id)
INNER JOIN mimiciii.d_icd_diagnoses
USING(icd9_code)
WHERE
short_title LIKE '%sepsis%';


SELECT DISTINCT d.itemid, label from mimiciii.d_items d INNER JOIN 
mimiciii.chartevents USING(itemid)
INNER JOIN mimiciii.icustays
USING(hadm_id,icustay_id)
INNER JOIN mimiciii.diagnoses_icd
USING(hadm_id)
INNER JOIN mimiciii.d_icd_diagnoses
USING(icd9_code)
WHERE
short_title LIKE '%sepsis%';

SELECT DISTINCT d.itemid, label from mimiciii.d_labitems d INNER JOIN 
mimiciii.labevents USING(itemid)
INNER JOIN mimiciii.icustays
USING(hadm_id)           
INNER JOIN mimiciii.diagnoses_icd
USING(hadm_id)
INNER JOIN mimiciii.d_icd_diagnoses
USING(icd9_code)
WHERE
short_title LIKE '%sepsis%';

SELECT COUNT(*) FROM (SELECT DISTINCT d.itemid, label, charttime from mimiciii.d_labitems d INNER JOIN mimiciii.labevents USING(itemid)
INNER JOIN mimiciii.icustays
USING(hadm_id)
INNER JOIN mimiciii.diagnoses_icd
USING(hadm_id)
INNER JOIN mimiciii.d_icd_diagnoses
USING(icd9_code)
WHERE
short_title LIKE '%sepsis%') foo;


