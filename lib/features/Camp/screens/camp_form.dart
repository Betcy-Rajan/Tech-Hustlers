import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nearsq/features/Camp/controllers/camp_controller.dart';
import 'package:nearsq/features/Camp/models/camp_models.dart';
import 'package:nearsq/utilis/constants/sizes.dart';
 
import 'package:nearsq/utilis/helpers/helper_functions.dart';
import 'package:nearsq/utilis/validators/validation.dart';

class CampForm extends StatelessWidget {
  const CampForm({super.key});

  @override
  Widget build(BuildContext context) {
    final bool dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(CampController());
    GlobalKey<FormState> campFormKey = GlobalKey<FormState>();
     final CampController _campController = Get.put(CampController());
  final TextEditingController _nameController = TextEditingController();
   final TextEditingController _peopleController = TextEditingController();
   final TextEditingController _resourcesController = TextEditingController(); //Form

    return  Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Form(
          key: controller.campFormKey,
          child: Column(
            children: [
              // Camp Name
              TextFormField(
                controller: _nameController,
                validator: (value) => TValidator.validateEmptyText(value, 'Camp Name'),
                decoration: const InputDecoration(
                  hintText: 'Camp Name',
                  prefixIcon: Icon(Iconsax.home), // Use appropriate icon
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
      
              // People Admitted
              TextFormField(
                controller: _peopleController,
                validator: (value) => TValidator.validateEmptyText(value, 'People Admitted'),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'People Admitted',
                  prefixIcon: Icon(Iconsax.people), // Use appropriate icon
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
      
              // Deficient Resources
              TextFormField(
                controller: _resourcesController,
                validator: (value) => TValidator.validateEmptyText(value, 'location'),
                decoration: const InputDecoration(
                  hintText: 'Location',
                  prefixIcon: Icon(Iconsax.warning_2), // Use appropriate icon
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
      
              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final camp = Camp(
                    id: '', // Firestore will generate the ID
                    name: _nameController.text,
                    peopleAdmitted: int.tryParse(_peopleController.text) ?? 0,
                    location: _resourcesController.text,);
                    controller.addCamp(camp);
                  },
                  child: Text('Add Camp'),
                ),
              ),
            ],
          ),
        ),
      );
    
  }
}