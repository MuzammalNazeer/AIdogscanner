import 'package:cached_network_image/cached_network_image.dart';
import 'package:dog_breed/Valid/AppColors.dart';
import 'package:dog_breed/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class Shopview extends StatefulWidget {
  const Shopview({super.key});

  @override
  State<Shopview> createState() => _ShopviewState();
}

class _ShopviewState extends State<Shopview> {
  int _selectedCategoryIndex = 4; // "House" is selected in design
  final List<String> _categories = [
    "All",
    "Breeds",
    "Cloth",
    "Shower",
    "House",
    "Care"
  ];

  final List<Map<String, dynamic>> _products = [
    {
      "title": "Lorem ipsum dolor",
      "image": "assets/images/image 46.png",
      "price": "Rs.674.25",
      "oldPrice": "\$899.00",
      "discount": "50% off",
      "subtitle": "Multiple sizes available"
    },
    {
      "title": "Lorem ipsum dolor",
      "image": "assets/images/image 46.png",
      "price": "\$329.00",
      "oldPrice": "\$629.00",
      "discount": "30% off",
      "subtitle": "Multiple sizes available"
    },
    {
      "title": "Lorem ipsum dolor",
      "image": "assets/images/image 46.png",
      "price": "Rs.674.25",
      "oldPrice": "\$899.00",
      "discount": "50% off",
      "subtitle": "Multiple sizes available"
    },
    {
      "title": "Lorem ipsum dolor",
      "image": "assets/images/image 46.png",
      "price": "\$329.00",
      "oldPrice": "\$629.00",
      "discount": "30% off",
      "subtitle": "Multiple sizes available"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Shop",
          style: TextStyle(
            color: Colors.black,
            fontSize: 28.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined,
                color: Colors.black, size: 28.sp),
            onPressed: () {},
          ),
          SizedBox(width: 10.w),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            // Search Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search for Dog",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 16.sp),
                  prefixIcon: const Icon(Icons.search, color: Colors.black),
                  contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            // Hero Banner
            Container(
              width: double.infinity,
              height: 200.h,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Bulldog Special\nBreeds",
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF272727),
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        "Lorem ipsum dolor site smith",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.vibrantPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.w, vertical: 8.h),
                          elevation: 0,
                        ),
                        child: Text(
                          "Shop Now",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: -10,
                    bottom: -10,
                    child: Image.asset(
                      'assets/images/image 46.png',
                      fit: BoxFit.contain,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10.h),
            // Pagination Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  4,
                  (index) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index == 0
                              ? AppColors.vibrantPurple
                              : Colors.grey.shade300,
                        ),
                      )),
            ),
            SizedBox(height: 20.h),
            // Categories
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.asMap().entries.map((entry) {
                  int idx = entry.key;
                  String cat = entry.value;
                  bool isSelected = idx == _selectedCategoryIndex;
                  return Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategoryIndex = idx;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFF5F5F5)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(30.r),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : Colors.grey.shade200,
                          ),
                        ),
                        child: Text(
                          cat,
                          style: TextStyle(
                            color: isSelected ? Colors.black : Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20.h),
            // Featured Products Title
            Text(
              "Featured Products",
              style: TextStyle(
                fontSize: 18.sp,
                color: const Color(0xFF484D54),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 15.h),
            // Grid
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 0.65,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return _buildProductCard(index);
              },
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(int index) {
    final product = _products[index];

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RoutesName.productDetail,
            arguments: product);
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16.r)),
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16.r)),
                      child: product['image'].toString().startsWith('http')
                          ? CachedNetworkImage(
                              imageUrl: product['image'],
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported)),
                            )
                          : Image.asset(
                              product['image'],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.image_not_supported)),
                            ),
                    ),
                  ),
                  Positioned(
                    top: 12.h,
                    left: 0,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(4.r),
                            bottomRight: Radius.circular(4.r)),
                      ),
                      child: Text(
                        product['discount'],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10.h,
                    right: 10.w,
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.8),
                      radius: 14.r,
                      child: Icon(Icons.favorite_border,
                          size: 16.sp, color: Colors.black54),
                    ),
                  ),
                  if (index == 0) // Verified badge for first item
                    Positioned(
                      bottom: 8.h,
                      right: 8.w,
                      child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: Icon(Icons.verified,
                              color: Colors.blue, size: 18.sp)),
                    )
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['title'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                              color: const Color(0xFF272727)),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          product['subtitle'],
                          style: TextStyle(color: Colors.grey, fontSize: 10.sp),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          product['price'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: const Color(0xFF272727)),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          product['oldPrice'],
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.sp,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
