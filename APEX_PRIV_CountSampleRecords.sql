select count(distinct sampleid)
from CI_PXR_CAM_PEAK_RECORD
INNER JOIN (select SAMPLEID, DESCRIPTION, INFORMATION, NAME from CI_PXD_SAMPLEINFORMATION) USING (SAMPLEID)
INNER JOIN (select SAMPLEID, FILENAME, ASSAYDATE, CREATIONDATE, ASSAYNUMBER from CI_PXD_SAMPLE) USING (SAMPLEID)
WHERE ASSAYDATE < '01-OCT-2021' AND ASSAYDATE > '01-OCT-20' AND NAME NOT LIKE '%QA%'