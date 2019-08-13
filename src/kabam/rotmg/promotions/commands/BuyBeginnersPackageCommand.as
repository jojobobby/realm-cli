package kabam.rotmg.promotions.commands
{
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.PaymentData;
   import kabam.rotmg.account.core.signals.OpenAccountPaymentSignal;
   import kabam.rotmg.account.core.view.RegisterPromptDialog;
   import kabam.rotmg.account.kabam.KabamAccount;
   import kabam.rotmg.account.web.WebAccount;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.promotions.model.BeginnersPackageModel;
   import kabam.rotmg.promotions.signals.MakeBeginnersPackagePaymentSignal;
   import kabam.rotmg.promotions.view.WebChoosePaymentTypeDialog;
   
   public class BuyBeginnersPackageCommand
   {
      
      private static const REGISTER_DIALOG_TEXT:String = "In order to buy the Beginners package, you must be a registered user.";
       
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var model:BeginnersPackageModel;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var openAccountPayment:OpenAccountPaymentSignal;
      
      [Inject]
      public var makePayment:MakeBeginnersPackagePaymentSignal;
      
      public function BuyBeginnersPackageCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         if(this.account.isRegistered())
         {
            this.openAccountSpecificPaymentScreen();
         }
         else
         {
            this.promptUserToRegisterAndAbort();
         }
      }
      
      private function openAccountSpecificPaymentScreen() : void
      {
         if(this.account is WebAccount || this.account is KabamAccount)
         {
            this.openDialog.dispatch(new WebChoosePaymentTypeDialog());
         }
         else
         {
            this.makePaymentImmediately();
         }
      }
      
      private function makePaymentImmediately() : void
      {
         var data:PaymentData = new PaymentData();
         data.offer = this.model.getOffer();
         this.makePayment.dispatch(data);
      }
      
      private function promptUserToRegisterAndAbort() : void
      {
         this.openDialog.dispatch(new RegisterPromptDialog(REGISTER_DIALOG_TEXT));
      }
   }
}
