/**
 * Controller class for RelatedOpportunities
 */ 
public class RelatedOpportunities 
{
    public List<wrapOpportunity> oppAll {get;set;}    
    public Account acc {get; set;} 
    public Opportunity  oppToCreate {get; set;}
    
    /**
     * Constructor to get the Account Record Id
     */
    public RelatedOpportunities(ApexPages.StandardController controller) 
    {
        this.acc= (Account)controller.getRecord();
        fetchOpportunity();
    }
    
    /**
     * Method to return the Account
     */
    public Account getAccount()
    {
        Account acc = [SELECT id,Name FROM Account where id = :acc.id];
        return acc;
    }
    
    /**
     * Method to fetch the Opportunity from current Account and add it to the wrapper List
     */
    public void fetchOpportunity()
    {
        oppAll = new List<wrapOpportunity>();   
        List<Opportunity> oppRelatedToAccount = [SELECT id, Name, Account.Name,StageName, CloseDate 
                                                    FROM Opportunity WHERE 
                                                    AccountId = :acc.Id];
        
        for(Opportunity oppty: oppRelatedToAccount) 
        {
            wrapOpportunity wpOpp = new wrapOpportunity();
            wpOpp.oppData= oppty;
            wpOpp.blnIsView = true; // when true will have Del button
            oppAll.add(wpOpp);
        }
    }
    
    /**
     * Method to delete the Opportunity
     */
    public void deleteOpp() 
    {
        String indexData = ApexPages.currentPage().getParameters().get('indexInsert');
        if(!String.isBlank(indexData))
        {
            Integer indexI = Integer.valueOf(indexData);
            delete oppAll[indexI].oppData;
            fetchOpportunity();
        }
        
    }
    
    /**
     * Method to add a new Row before it is saved.
     */
    public void addnewOpp() 
    {        
        oppToCreate = new Opportunity();
        oppToCreate.AccountId = acc.Id;
        wrapOpportunity oppNew = new wrapOpportunity();
        oppNew.oppData = oppToCreate;
        oppNew.blnIsView =false; // when false will have Save button 
        oppAll.add(oppNew);  
    }
    
    /**
     * Method to insert the new Opportunity
     */
    public void insertData() 
    {
        String indexData = ApexPages.currentPage().getParameters().get('indexInsert');
        if(!String.isBlank(indexData)) 
        {
            Integer indexI = Integer.valueOf(indexData);
            insert oppAll[indexI].oppData;
            fetchOpportunity();
        }
        
    }
    
    /**
     * Wrapper class
     */
    public class wrapOpportunity 
    {
        public Opportunity oppData{get;set;}
        public boolean blnIsView {get;set;}
        public wrapOpportunity() 
        {
            oppData = new Opportunity();
            blnIsView = false; // set default to false
        }
    }
}