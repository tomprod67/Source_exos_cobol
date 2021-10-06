      $set sourceformat(variable)

      *> Namespace: TestTuto.Properties

      *>> <summary>
      *>>   Une classe de ressource fortement typée destinée, entre autres, à la consultation des chaînes localisées.
      *>> </summary>
      *> Cette classe a été générée automatiquement par la classe StronglyTypedResourceBuilder
      *> à l'aide d'un outil, tel que ResGen ou Visual Studio.
      *> Pour ajouter ou supprimer un membre, modifiez votre fichier .ResX, puis réexécutez ResGen
      *> avec l'option /str ou régénérez votre projet VS.
       class-id TestTuto.Properties.Resources
           attribute System.CodeDom.Compiler.GeneratedCode("System.Resources.Tools.StronglyTypedResourceBuilder", "16.0.0.0")
           attribute System.Diagnostics.DebuggerNonUserCode()
           attribute System.Runtime.CompilerServices.CompilerGenerated()
       .

       working-storage section.
       01 resourceMan type System.Resources.ResourceManager static.
       01 resourceCulture type System.Globalization.CultureInfo static.

       method-id get property ResourceManager static
           attribute System.ComponentModel.EditorBrowsable(type System.ComponentModel.EditorBrowsableState::Advanced) final internal.
       local-storage section.
       01 temp type System.Resources.ResourceManager.
       procedure division returning return-item as type System.Resources.ResourceManager.
       if type System.Object::ReferenceEquals(resourceMan null) then 
           set temp to new System.Resources.ResourceManager("TestTuto.Properties.Resources" type of TestTuto.Properties.Resources::Assembly)
           set resourceMan to temp
       end-if
       set return-item to resourceMan
       goback
       end method.

       method-id get property Culture static
           attribute System.ComponentModel.EditorBrowsable(type System.ComponentModel.EditorBrowsableState::Advanced) final internal.
       procedure division returning return-item as type System.Globalization.CultureInfo.
       set return-item to resourceCulture
       goback
       end method.

       method-id set property Culture static final internal.
       procedure division using by value #value as type System.Globalization.CultureInfo.
       set resourceCulture to #value
       end method.

       method-id NEW
                    attribute System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode").
       procedure division.

       end method.

       end class.
