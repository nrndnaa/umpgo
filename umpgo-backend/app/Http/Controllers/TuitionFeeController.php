<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Models\FeeRecord;
use App\Models\Payment;
use App\Models\DueDateSetting;

class TuitionFeeController extends Controller
{

    // =========================================
    // SET DUE DATE
    // =========================================
    public function setDueDate(Request $request)
{
    $request->validate([
        'semester' => 'required',
        'dueDate' => 'required|date',
        'blockType' => 'required',
    ]);

    // SAVE DUE DATE SETTING
    $dueDate = DueDateSetting::create([
        'semester' => $request->semester,
        'dueDate' => $request->dueDate,
        'blockType' => $request->blockType,
        'created_by' => 'Treasury',
    ]);

    // UPDATE ALL FEE RECORDS OF SAME SEMESTER
    FeeRecord::where('semester', $request->semester)
        ->update([
            'dueDate' => $request->dueDate
        ]);

    return response()->json([
        'message' => 'Due date created successfully',
        'data' => $dueDate
    ], 201);
}



    // =========================================
    // GET ALL DUE DATES
    // =========================================
    public function getDueDates()
    {
        return response()->json(
            DueDateSetting::all()
        );
    }



    // =========================================
    // CREATE FEE RECORD
    // =========================================
    public function createFeeRecord(Request $request)
    {
        $request->validate([
            'studentID' => 'required',
            'semester' => 'required',
            'totalFee' => 'required|numeric',
            'dueDate' => 'required|date',
        ]);

        $fee = FeeRecord::create([
            'studentID' => $request->studentID,
            'treasuryID' => 'TR001',
            'semester' => $request->semester,
            'totalFee' => $request->totalFee,
            'paidAmount' => 0,
            'dueDate' => $request->dueDate,
            'feeStatus' => 'Active',
        ]);

        return response()->json([
            'message' => 'Fee record created successfully',
            'data' => $fee
        ], 201);
    }



    // =========================================
    // GET ALL FEE RECORDS
    // =========================================
    public function getFeeRecords()
    {
        return response()->json(
            FeeRecord::all()
        );
    }



    // =========================================
    // MAKE PAYMENT
    // =========================================
    public function makePayment(Request $request)
    {
        $request->validate([
            'feeID' => 'required',
            'amount' => 'required|numeric',
            'paymentMethod' => 'required',
        ]);

        // CREATE PAYMENT
        $payment = Payment::create([
            'feeID' => $request->feeID,
            'amount' => $request->amount,
            'paymentMethod' => $request->paymentMethod,
            'paymentStatus' => 'Success',
            'paid_at' => now(),
        ]);

        // UPDATE PAID AMOUNT
        $feeRecord = FeeRecord::find($request->feeID);

        $feeRecord->paidAmount += $request->amount;

        $feeRecord->save();

        return response()->json([
            'message' => 'Payment successful',
            'data' => $payment
        ], 201);
    }


public function getFeeRecord($studentID)
{
    $record = FeeRecord::where('studentID', $studentID)->latest()->first();

    if (!$record) {
        return response()->json(['message' => 'No fee record found'], 404); // ← this triggers the snackbar
    }

    return response()->json($record);
}


    // =========================================
    // GET ALL PAYMENTS
    // =========================================
    public function getPayments()
    {
        return response()->json(
            Payment::all()
        );
    }
}