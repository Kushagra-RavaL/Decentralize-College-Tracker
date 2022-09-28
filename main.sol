// SPDX-License-Identifier: 3.0
pragma solidity ^0.8.0;

contract DecentralizedCollegeTracker{
    address Admin;
    constructor() {
        Admin = msg.sender;
    }
    modifier OnlyAdmin() {
        require(msg.sender == Admin,"Only Admin Can Access !");
        _;
    }
// ------------- State Variables --------------
    address[] CollegeAddress;
    mapping(address => bool) ExistingCollege;

// Struct For College
    struct College{
        string CollName;
        address Colladdress;
        address CollAdmin;
        uint CollRegsNumber;
        bool PermissionToadd;
        uint NumberofStudents;
    }
    mapping(address => College) CollDetails;
    
    function addNewCollege(string memory CName, address _Cadd, address CAdmin, uint RegNum, bool Permission) OnlyAdmin public {
        CollDetails[_Cadd].Colladdress = _Cadd;
        CollDetails[_Cadd].CollName = CName;
        CollDetails[_Cadd].CollAdmin = CAdmin;
        CollDetails[_Cadd].CollRegsNumber = RegNum;
        CollDetails[_Cadd].PermissionToadd = Permission;
        // CollDetails[_Cadd]=College(CName,_Cadd,CAdmin,RegNum,false,0); Can also use this Method 
        CollegeAddress.push(_Cadd);
        ExistingCollege[_Cadd] =true;
    }

// Struct For Students 
    struct Student{
        address CollAddress;
        string StuName;
        uint PhnNum;
        string CourseName;
    }
    mapping(string=>Student) StuDetails;
    
    function addNewStudentToCollege(address _Cadd,string memory _SName, uint _phnNum, string memory _course) public {
        require(ExistingCollege[_Cadd]!=false,"College is Not Registered !");
        require(CollDetails[_Cadd].PermissionToadd == true,"PERMISSION DENIED !");
        require(StuDetails[_SName].PhnNum != _phnNum,"You can't use the same PhnNumber");
        StuDetails[_SName]=Student(_Cadd,_SName,_phnNum,_course); // We can use this also but here in the bracket should be in order W/R to structure
        CollDetails[_Cadd].NumberofStudents++;
    }
//  BLOCK UNBLOCK COLLEGE PERMISSION TO ADD STUDENTS 
    function blockCollegeToaddStudents(address _Cadd) OnlyAdmin public {
        CollDetails[_Cadd].PermissionToadd = false;
    }
    
    function unblockCollegeToaddStudents(address _Cadd) OnlyAdmin public {
        CollDetails[_Cadd].PermissionToadd = true;
    }

// CHANGE COURSE OF STUDENTS
    function changeStudentCourse(address _Cadd,string memory _SName,string memory NewCourse) public {
        require(ExistingCollege[_Cadd]!=false,"College is Not Registered !");
        require(CollDetails[_Cadd].CollAdmin == msg.sender," College Admin Should Only Change the Course");
        StuDetails[_SName].CourseName = NewCourse;
    }
// GET NUMBER OF ENROLLMENT
    function getNumberofStudentsforCollege(address _Cadd) view public returns(uint) {
        return CollDetails[_Cadd].NumberofStudents;
    }

// FETCH DETAILS for COLLEGE & STUDENTS 
    function viewStudentDetails(string memory _SName) public view returns(address,string memory,uint,string memory){
        require(ExistingCollege[msg.sender]!=false,"College is Not Registered !");
        return(StuDetails[_SName].CollAddress,StuDetails[_SName].StuName,StuDetails[_SName].PhnNum,StuDetails[_SName].CourseName);
    }

    function viewCollegeDetails(address _Cadd) public view returns(address,string memory,address, uint,uint) {
        require(ExistingCollege[_Cadd]!=false,"College is Not Registered !");
        return(CollDetails[_Cadd].Colladdress,
               CollDetails[_Cadd].CollName,
               CollDetails[_Cadd].CollAdmin,
               CollDetails[_Cadd].CollRegsNumber,
               CollDetails[_Cadd].NumberofStudents);
    }
}
