import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nearsq/features/users/Volunteer/controller/volunteer_controller.dart';
import 'package:nearsq/utilis/constants/sizes.dart';


import 'package:nearsq/utilis/helpers/helper_functions.dart';

import 'package:nearsq/utilis/validators/validation.dart';

class VolunteerRegistrationForm extends StatelessWidget {
  const VolunteerRegistrationForm({super.key});

  @override
  Widget build(BuildContext context) {
    final bool dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(VolunteerController());
   

    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteer Registration'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Form(
          key: controller.volunteerFormKey,
          child: Column(
            children: [
              // Name Field
              TextFormField(
                controller: controller.name,
                validator: (value) => TValidator.validateEmptyText(value, 'Name'),
                decoration: const InputDecoration(
                  hintText: 'Full Name',
                  prefixIcon: Icon(Iconsax.user),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
        
              // Phone Number
              TextFormField(
                controller: controller.phoneNumber,
                validator: (value) => TValidator.validatePhoneNumber(value),
                decoration: const InputDecoration(
                  hintText: 'Phone Number',
                  prefixIcon: Icon(Iconsax.call),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
        
              // Address
              TextFormField(
                controller: controller.address,
                validator: (value) => TValidator.validateEmptyText(value, 'Address'),
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Address',
                  prefixIcon: Icon(Iconsax.location),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
        
              // District Dropdown
              Obx(() => DropdownButtonFormField<String>(
                    value: controller.selectedDistrict.value,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.building),
                      hintText: 'Select District',
                    ),
                    items: controller.districts.map((district) {
                      return DropdownMenuItem(
                        value: district,
                        child: Text(district),
                      );
                    }).toList(),
                    onChanged: (value) => controller.selectedDistrict.value = value!,
                  )),
              const SizedBox(height: TSizes.spaceBtwInputFields),
        
              // Skills Dropdown
              Obx(() => DropdownButtonFormField<String>(
                    value: controller.selectedSkill.value,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.briefcase),
                      hintText: 'Select Skill',
                    ),
                    items: controller.skills.map((skill) {
                      return DropdownMenuItem(
                        value: skill,
                        child: Text(skill),
                      );
                    }).toList(),
                    onChanged: (value) => controller.selectedSkill.value = value!,
                  )),
              const SizedBox(height: TSizes.spaceBtwInputFields),
        
              // Location Button
              Obx(() => Text(
                    'Location: ${controller.currentLocation.value?.latitude ?? "N/A"}, ${controller.currentLocation.value?.longitude ?? "N/A"}',
                    style: Theme.of(context).textTheme.bodySmall,
                  )),
              ElevatedButton.icon(
                onPressed: () => controller.getCurrentLocation(),
                icon: const Icon(Iconsax.location),
                label: const Text('Get Current Location'),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
        
              // Register Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.registerVolunteer(),
                  child: const Text('Register as Volunteer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}