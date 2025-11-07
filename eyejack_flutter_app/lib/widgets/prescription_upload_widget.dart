import 'package:flutter/material.dart';

class PrescriptionUploadWidget extends StatelessWidget {
  final VoidCallback onUploadPrescription;
  final VoidCallback onEnterManually;
  final VoidCallback onEmailLater;

  const PrescriptionUploadWidget({
    super.key,
    required this.onUploadPrescription,
    required this.onEnterManually,
    required this.onEmailLater,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F9FA),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.remove_red_eye,
                size: 28,
                color: const Color(0xFF27916D),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Add Your Prescription',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Choose how you would like to provide your prescription details',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          _buildOptionCard(
            context,
            icon: Icons.upload_file,
            title: 'Upload Prescription',
            description: 'Upload your prescription image or PDF',
            color: const Color(0xFF27916D),
            onTap: onUploadPrescription,
          ),
          const SizedBox(height: 12),
          _buildOptionCard(
            context,
            icon: Icons.edit_note,
            title: 'Enter Manually',
            description: 'Fill in your prescription details',
            color: const Color(0xFF2196F3),
            onTap: onEnterManually,
          ),
          const SizedBox(height: 12),
          _buildOptionCard(
            context,
            icon: Icons.email_outlined,
            title: 'Email Later',
            description: 'We\'ll send you an email to submit later',
            color: const Color(0xFFFF9800),
            onTap: onEmailLater,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 28,
                color: color,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}

