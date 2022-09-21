public class ReportChartController {
    
    public class TableRecord {
        @AuraEnabled public string col1;
        @AuraEnabled public string col2;
        @AuraEnabled public string col3;
    }
    
    @AuraEnabled
    public static String getreport(String reportId, String filterStr, Boolean getAllData){
        //Using report id for example purpose
        List<Report> lstReportRec = [SELECT
                                     Id
                                     FROM Report
                                     WHERE Id = :reportID];
        
        system.debug('lstReportRec:' + lstReportRec);
        
        String rptId = '00O0x000000G0G6EAK';
        if(lstReportRec.size() > 0) {
            rptId = lstReportRec[0].Id;

            // Get the report metadata
            Reports.ReportDescribeResult describe = Reports.ReportManager.describeReport(reportId);
            Reports.ReportMetadata reportMd = describe.getReportMetadata();

            
            if(filterStr != null) {
                
                // Override filter and run report
                List<Reports.ReportFilter> filters = reportMd.getReportFilters();
                System.debug('filters: ' + filters);
                
                if(filters != null && filters.size() > 0) {
                    
                    if(filterStr.indexOf(':') == -1) {
	                    filters[0].setValue(filterStr);                    
                    } else {
                        MAP<String,String> mapFilters = new MAP<String,String>();
                        String[] arrInFilter = filterStr.split('~');
                        for(String ar1 :arrInFilter) {
                            System.debug('ar1: ' + ar1);
                            String[] arrFilterParts = ar1.split(':');
                            mapFilters.put(arrFilterParts[0],arrFilterParts[1]);
                        }
                        System.debug('mapFilters: ' + mapFilters);
                        
                        for(Reports.ReportFilter rp :filters) {
                            System.debug('filter: ' + rp);
                            String col = rp.getColumn();
                            String fndFilterVal = mapFilters.get(col);
                            if(fndFilterVal != null) {
                                rp.setValue(fndFilterVal); 
                            }
                        }
                        System.debug('filters: ' + filters);
                    }
                    
                }
            }
        
            if(getAllData == null) {
                getAllData = false;
            }
            Reports.ReportResults reportResult =
                Reports.ReportManager.runReport(rptId, reportMd, getAllData);
            
            system.debug('reportResult:' + reportResult);
            
            return JSON.serialize(reportResult);
        } else {
            return null;
        }
    }
}