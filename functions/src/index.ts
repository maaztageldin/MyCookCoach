import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as stripeLib from "stripe";

const stripe = new stripeLib.Stripe(functions.config().stripe.secret, {
  apiVersion: "2024-06-20",
});

admin.initializeApp();

export const createPaymentIntent = functions.https.onCall(
  async (data) => {
    const amount = data.amount;
    const currency = data.currency;

    try {
      const paymentIntent = await stripe.paymentIntents.create({
        amount: amount,
        currency: currency,
      });

      return {
        clientSecret: paymentIntent.client_secret,
      };
    } catch (error) {
      console.error("Error creating payment intent:", error);
      throw new functions.https.HttpsError(
        "unknown",
        "Failed to create payment intent"
      );
    }
  }
);
