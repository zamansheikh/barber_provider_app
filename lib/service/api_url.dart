class ApiConstant {
  static const baseUrl = "http://143.198.100.240/";
  static const paymentPublicKey =
      "FLWPUBK_TEST-b5bb5bbff5a355e6f0c070063af0f04b-X";

  static const paymentScretKey =
      "FLWSECK_TEST-8309a9e1bb5220b153b3da94fdbe0cae-X";

  static const paymentScrethash = "FLWSECK_TEST47a272d5d15e";

  //=================================Auth===============================

  //=========Social login / Sign up==========

  static const socialAuth = "api/social-login";

  //=========Sign UP==========
  static const register = "api/register";
  static const verified = "api/verified";
  static const resendOtp = "api/resendOtp";

  //=========Sign IN==========
  static const login = "api/login";
  static const resetPassword = "api/reset-password";

  //===================Home Screen=========================
  static const showCategory = "api/category-search/";

  //===================Provider=========================
  static const addProvider = "api/post/provider";
  static const updateProvider = "api/update/provider";

  //===================Post Service=========================
  static const postService = "api/post/service";
  static const updateService = "api/post/update/service";

  //===================Post Catalouge=========================
  static const postCatalouge = "api/post/catalouge";
  static const updateCatalouge = "api/update/catalouge";

  //===================Profile=========================
  static const getProfile = "api/profile";
  static const profileUpdate = "api/profileUpdate";

  //===================Post Catalouge=========================
  static const home = "api/get/provider";

  //==========================Settings===============================

  static const logOut = "api/logout";
  static const changePassword = "api/change-password";
  static const aboutPrivacyTerms = "api/show-website-pages";
  static const myPlan = "api/my-plan";

  //===================Service Details=========================
  static const serviceDetails = "api/service/details/";

  //===================Service Details=========================
  static const showPackage = "api/show-package";

  //===========================Payment===============================
  static const makePayment = "api/pay/";
  static const paymentSuccess = "api/payment-success";

  //===================Notification===============================
  static const notification = "api/send/booking/request/salon";

  //========================Booking Request============================
  static const bookingReq = "api/booking/request";
  static const reSchedule = "api/re/schedule/appoinment";

  static const bookingReqUpdate = "api/booking/accept";

  //===================Booking Req===============================
  static const approvedBooking = "api/approved/booking";

  //===================Bookings===============================
  static const bookings = "api/booking";

  //===================Booking History===============================
  static const bookingHistory = "api/booking/history";

  //==============================Income===============================
  static const weeklyIncome = "api/week/income";
  static const monthIncome = "api/month/income";
  static const yearIncome = "api/year/income";

  //===================Service List===============================
  static const serviceList = "api/provider/all/service/";

  //===================Service List===============================
  static const catalougeList = "api/get/catalouge/";

  //===================Service List===============================
  static const review = "api/provider/review";
}
