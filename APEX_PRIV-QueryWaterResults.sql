/*select SAMPLEID, PSENERGY, NAME, FILENAME, ASSAYDATE, CREATIONDATE, INFORMATION from CI_PXR_CAM_PEAK_RECORD */
select SAMPLEID, NCLNAME, NCLMDA, NCLWTMEAN, NAME, FILENAME, ASSAYDATE, CREATIONDATE, INFORMATION from CI_PXR_CAM_NUCL_RECORD
INNER JOIN (select SAMPLEID, INFORMATION from CI_PXD_SAMPLEINFORMATION) USING (SAMPLEID)
INNER JOIN (select SAMPLEID, DESCRIPTION, NAME from CI_PXD_SAMPLESETUP) USING (SAMPLEID)
INNER JOIN (select SAMPLEID, FILENAME, ASSAYDATE, CREATIONDATE from CI_PXD_SAMPLE) USING (SAMPLEID)
where ASSAYDATE > '01-JAN-2021' AND (NAME LIKE '%-HFD-%' OR NAME LIKE '%-CH-%' OR NAME LIKE '%-HD-%' OR NAME LIKE '%-DP-%' OR NAME LIKE '%SW%');