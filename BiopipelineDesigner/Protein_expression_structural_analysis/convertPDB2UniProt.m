function UniPROTIDs = convertPDB2UniProt(PDBIDs)
% Convert PDB IDs to UnitprotKB IDs

import matlab.net.http.*
import matlab.net.http.field.*
import matlab.net.http.io.*
baseurl = "https://rest.uniprot.org/idmapping";

% send conversion job
ids  = strjoin(PDBIDs,",");
url  = baseurl + "/run";
body = MultipartFormProvider('from','PDB','to','UniProtKB','ids',ids);
req  = RequestMessage('POST', [], body);
resp = req.send(url);

% get job status until FINISHED
status = "";
urlstatus = baseurl + "/status/" + resp.Body.Data.jobId;
while status ~= "FINISHED"
    pause(2) % wait 2 seconds
    response = RequestMessage().send(urlstatus);
    status = response.Body.Data.jobStatus;
end

% retrieve results
urlresults = response.Header.getFields('Location');
url = urlresults.Value + "?format=list";

options = weboptions('HeaderFields', {'Accept-Encoding' 'identity'});
results = webread(url,options);

UniPROTIDs = string(splitlines(deblank(results)));
UniPROTIDs = unique(UniPROTIDs);

end
