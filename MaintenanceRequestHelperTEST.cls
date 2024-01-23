@istest
public with sharing class MaintenanceRequestHelperTest {
    // implement scheduled code here

    private static final string STATUS_NEW = 'New';
    private static final string WORKING = 'Working';
    private static final string CLOSED = 'Closed';
    private static final string REPAIR = 'Repair';
    private static final string REQUEST_ORIGIN = 'Web';
    private static final string REQUEST_TYPE = 'Routine Maintenance';
    private static final string REQUEST_SUBJECT = 'Testing subject';

    private static Vehicle__c createVehicle(){
        Vehicle__c Vehicle = new Vehicle__c(name = 'Super Duty');
        return Vehicle;
    }

    private static Product2 createEQ(){
        Product2 equipment = new Product2(name='SuperDuty Tires',
                                            lifespan_months__c = 10,
                                            maintenance_cycle__c = 10,
                                            replacement_part__c = true);
        return equipment;
    }

    private static Case createMaintenanceRequest(id vehicleId, id equipmentId){
        Case mr = new Case(Type = REPAIR,
                            Status = STATUS_NEW,
                            Origin = REQUEST_ORIGIN,
                            Subject = REQUEST_SUBJECT,
                            ProductId = equipmentId,
                            Vehicle__c = vehicleId );
        return mr;
    }

    private static Equipment_Maintenance_Item__c createWorkPart(id equipmentId, id requestId){
        Equipment_Maintenance_Item__c emi = new Equipment_Maintenance_Item__c(Equipment__c = equipmentId , Maintenance_Request__c = requestId);

        return emi;
    }

    @istest
    private static void testMaintenanceRequestPositive(){
        Vehicle__c vehicle = createVehicle();
        insert vehicle;
        id vehicleId = vehicle.Id;

        Product2 equipment = createEQ();
        insert equipment;
        id equipmentId = equipment.Id;

        Case caseToUpdate = createMaintenanceRequest(vehicleId,equipmentId);
        insert caseToUpdate;

        Equipment_Maintenance_Item__c workPart = createWorkPart(equipmentId,caseToUpdate.Id);
        insert workPart;

        test.startTest();
        caseToUpdate.Status = CLOSED;
        update caseToUpdate;
        test.stopTest();

        Case newMR = [SELECT Id, Subject, Type, ProductId, Date_Reported__c, Vehicle__c, Date_Due__c FROM Case WHERE Status=:STATUS_NEW];

        Equipment_Maintenance_Item__c workPartResult = [SELECT Id FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c=:newMR.Id];

        System.assert(workPartResult != null);
        System.assert(newMR.Subject != null);
        System.assert(newMR.Type, REQUEST_TYPE);
        System.assert(newMR.ProductId, equipmentId);
        System.assert(newMR.Vehicle__c, vehicleId);
        System.assert(newMR.Date_Reported__c,system.Today());
    }

    @istest
    private static void testMaintenanceRequestNegative(){
        Vehicle__c vehicle = createVehicle();
        insert vehicle;
        id vehicleId = vehicle.Id;

        Product2 equipment = createEQ();
        insert equipment;
        id equipmentId = equipment.Id;

        Case emptyMR = createMaintenanceRequest(vehicleId,equipmentId);
        insert emptyMR;

        Equipment_Maintenance_Item__c workPart = createWorkPart(equipmentId, emptyMR.Id);
        insert workPart;

        test.startTest();
        emptyMR.Status = WORKING;
        update emptyMR;
        test.stopTest();

        List<Case> allRequests = [SELECT Id FROM Case];

        Equipment_Maintenance_Item__c workPartResult = [SELECT Id FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c = :emptyMR.Id];

        System.assert(workPartResult != null);
        System.assert(allRequests.size() == 1);

    }

    @istest
    private static void testMaintenanceRequestBulk(){
        List<Vehicle__c> vehicleList = new List<Vehicle__c>();
        List<Product2> equipmentList = new List<Product2>();
        List<Equipment_Maintenance_Item__c> emiList = new List<Equipment_Maintenance_Item__c>();
        List<Case> mrList = new List<Case>();
        List<Id> oldMRids = new List<Id>();

        for(integer i = 0; i< 300; i++){
            vehicleList.add(createVehicle());
            equipmentList.add(createEQ());
        }
        insert vehicleList;
        insert equipmentList;

        for(integer i = 0; i<300;i++){
            mrList.add(createMaintenanceRequest(vehicleList.get(i).id, equipmentList.get(i).id));
        }
        insert mrList;

        for(integer i = 0; i<300; i++){
            emiList.add(createWorkPart(equipmentList.get(i).Id, mrList.get(i).id));

        }
        insert emiList;

        test.startTest();
        for(Case mr : mrList){
            mr.Status = CLOSED;
            oldMRids.add(mr.Id);
        }
        update mrList;
        test.stopTest();

        List<Case> allMRs = [SELECT Id FROM Case WHERE Status =: STATUS_NEW];

        List<Equipment_Maintenance_Item__c> EMIs = [SELECT Id FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c IN: oldMRids];

        System.assert(allMRs.size()==300);
    }


}