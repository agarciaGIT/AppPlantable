public class packingSlipPDFPicker {
    
    public Date x_date    {get;set;}
    public String sdate    {get;set;}
    public String msg  {get;set;}
    public Boolean mskOn {get;set;}
    
    public packingSlipPDFPicker () {       
        mskOn = False;
    }
    
    public void setDateString() {
        DateTime dt = DateTime.newInstance(x_date.year(), x_date.month(), x_date.day());
        sdate = dt.format('yyyy-MM-dd');
    }
    
    public PageReference chefDownload() {
        PageReference pageRef = new PageReference('/apex/packingSlipPDF?shipdate=' + sdate+'&type=chef&msk='+mskOn);
        return pageRef;
    }
    
    public PageReference chefAlacarte() {
        PageReference pageRef = new PageReference('/apex/packingSlipPDF?shipdate=' + sdate+'&type=cart&msk='+mskOn);
        return pageRef;
    }

    public PageReference chefAlacarteMarkPreview() {
        PageReference pageRef = new PageReference('/apex/packingSlipPDF?shipdate=' + sdate+'&type=cart&mark=false&msk='+mskOn);
        return pageRef;
    }
    
    public PageReference chefAlacarteMark() {
        PageReference pageRef = new PageReference('/apex/packingSlipPDF?shipdate=' + sdate+'&type=cart&mark=true&msk='+mskOn);
        return pageRef;
    }
    

}