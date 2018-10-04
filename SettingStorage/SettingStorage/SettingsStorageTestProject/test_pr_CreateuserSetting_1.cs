using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Text;
using Microsoft.Data.Tools.Schema.Sql.UnitTesting;
using Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace SettingsStorageTestProject
{
  [TestClass()]
  public class test_pr_CreateuserSetting_1 : SqlDatabaseTestClass
  {

    public test_pr_CreateuserSetting_1()
    {
      InitializeComponent();
    }

    [TestInitialize()]
    public void TestInitialize()
    {
      base.InitializeTest();
    }
    [TestCleanup()]
    public void TestCleanup()
    {
      base.CleanupTest();
    }

    #region Designer support code

    /// <summary> 
    /// Required method for Designer support - do not modify 
    /// the contents of this method with the code editor.
    /// </summary>
    private void InitializeComponent()
    {
      Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dbo_pr_CreateUserSettingDataTypeTest_TestAction;
      System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(test_pr_CreateuserSetting_1));
      Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.InconclusiveCondition inconclusiveCondition1;
      this.dbo_pr_CreateUserSettingDataTypeTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
      dbo_pr_CreateUserSettingDataTypeTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
      inconclusiveCondition1 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.InconclusiveCondition();
      // 
      // dbo_pr_CreateUserSettingDataTypeTestData
      // 
      this.dbo_pr_CreateUserSettingDataTypeTestData.PosttestAction = null;
      this.dbo_pr_CreateUserSettingDataTypeTestData.PretestAction = null;
      this.dbo_pr_CreateUserSettingDataTypeTestData.TestAction = dbo_pr_CreateUserSettingDataTypeTest_TestAction;
      // 
      // dbo_pr_CreateUserSettingDataTypeTest_TestAction
      // 
      dbo_pr_CreateUserSettingDataTypeTest_TestAction.Conditions.Add(inconclusiveCondition1);
      resources.ApplyResources(dbo_pr_CreateUserSettingDataTypeTest_TestAction, "dbo_pr_CreateUserSettingDataTypeTest_TestAction");
      // 
      // inconclusiveCondition1
      // 
      inconclusiveCondition1.Enabled = true;
      inconclusiveCondition1.Name = "inconclusiveCondition1";
    }

    #endregion


    #region Additional test attributes
    //
    // You can use the following additional attributes as you write your tests:
    //
    // Use ClassInitialize to run code before running the first test in the class
    // [ClassInitialize()]
    // public static void MyClassInitialize(TestContext testContext) { }
    //
    // Use ClassCleanup to run code after all tests in a class have run
    // [ClassCleanup()]
    // public static void MyClassCleanup() { }
    //
    #endregion

    [TestMethod()]
    public void dbo_pr_CreateUserSettingDataTypeTest()
    {
      SqlDatabaseTestActions testActions = this.dbo_pr_CreateUserSettingDataTypeTestData;
      // Execute the pre-test script
      // 
      System.Diagnostics.Trace.WriteLineIf((testActions.PretestAction != null), "Executing pre-test script...");
      SqlExecutionResult[] pretestResults = TestService.Execute(this.PrivilegedContext, this.PrivilegedContext, testActions.PretestAction);
      try
      {
        // Execute the test script
        // 
        System.Diagnostics.Trace.WriteLineIf((testActions.TestAction != null), "Executing test script...");
        SqlExecutionResult[] testResults = TestService.Execute(this.ExecutionContext, this.PrivilegedContext, testActions.TestAction);
      }
      finally
      {
        // Execute the post-test script
        // 
        System.Diagnostics.Trace.WriteLineIf((testActions.PosttestAction != null), "Executing post-test script...");
        SqlExecutionResult[] posttestResults = TestService.Execute(this.PrivilegedContext, this.PrivilegedContext, testActions.PosttestAction);
      }
    }
    private SqlDatabaseTestActions dbo_pr_CreateUserSettingDataTypeTestData;
  }
}
