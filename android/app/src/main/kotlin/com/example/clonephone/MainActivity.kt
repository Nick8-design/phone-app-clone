package com.example.clonephone

import android.database.Cursor
import android.net.Uri
import android.provider.CallLog
import android.provider.ContactsContract
import android.util.Base64
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.io.InputStream

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.contacts"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getFavoriteContacts" -> {
                    val favoriteContacts = getFavoriteContacts()
                    result.success(favoriteContacts)
                }
                "getFrequentlyCalledContacts" -> {
                    val frequentlyCalledContacts = getFrequentlyCalledContacts()
                    result.success(frequentlyCalledContacts)
                }
                "fetchContactPhoto" -> {
                    val photoUri = call.argument<String>("photoUri")
                    if (photoUri != null) {
                        val base64Photo = getContactPhotoBase64(photoUri)
                        if (base64Photo != null) {
                            result.success(base64Photo)
                        } else {
                            result.error("UNAVAILABLE", "Photo not available", null)
                        }
                    } else {
                        result.error("INVALID_ARGUMENT", "Photo URI is null", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun getFavoriteContacts(): List<Map<String, String?>> {
        val favorites = mutableListOf<Map<String, String?>>()

        try {
            val cursor: Cursor? = contentResolver.query(
                ContactsContract.Contacts.CONTENT_URI,
                null,
                "${ContactsContract.Contacts.STARRED}=?",
                arrayOf("1"), // "1" means the contact is marked as favorite
                null
            )

            cursor?.use {
                while (it.moveToNext()) {
                    val id = it.getString(it.getColumnIndex(ContactsContract.Contacts._ID))
                    val name = it.getString(it.getColumnIndex(ContactsContract.Contacts.DISPLAY_NAME))
                    val photoUri = it.getString(it.getColumnIndex(ContactsContract.Contacts.PHOTO_URI))

                    // Query phone numbers for the contact
                    val phonesCursor = contentResolver.query(
                        ContactsContract.CommonDataKinds.Phone.CONTENT_URI,
                        null,
                        "${ContactsContract.CommonDataKinds.Phone.CONTACT_ID} = ?",
                        arrayOf(id),
                        null
                    )

                    phonesCursor?.use { phones ->
                        while (phones.moveToNext()) {
                            val phone = phones.getString(
                                phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER)
                            )

                            // Add contact details to the list
                            val contact = mapOf(
                                "name" to name,
                                "phone" to phone,
                                "photoUri" to photoUri
                            )
                            favorites.add(contact)
                        }
                    }
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }

        return favorites
    }

    private fun getFrequentlyCalledContacts(): List<Map<String, String?>> {
        val frequentlyCalledContacts = mutableListOf<Map<String, String?>>()

        try {
            val cursor: Cursor? = contentResolver.query(
                CallLog.Calls.CONTENT_URI,
                arrayOf(CallLog.Calls.NUMBER, CallLog.Calls.CACHED_NAME, CallLog.Calls.DURATION),
                null,
                null,
                "${CallLog.Calls.DURATION} DESC" // Remove LIMIT, sort by duration
            )


            cursor?.use {
                while (it.moveToNext()) {
                    val number = it.getString(it.getColumnIndex(CallLog.Calls.NUMBER))
                    val name = it.getString(it.getColumnIndex(CallLog.Calls.CACHED_NAME)) ?: "Unknown"
                    val duration = it.getString(it.getColumnIndex(CallLog.Calls.DURATION))

                    val contact = mapOf(
                        "name" to name,
                        "phone" to number,
                        "duration" to duration
                    )
                    frequentlyCalledContacts.add(contact)
                }
            }
// Limit to top 10
            return frequentlyCalledContacts.take(10)



        } catch (e: Exception) {
                 e.printStackTrace()
        }

        return frequentlyCalledContacts
    }

    private fun getContactPhotoBase64(photoUri: String): String? {
        return try {
            val resolver = contentResolver
            val uri = Uri.parse(photoUri)
            val inputStream: InputStream? = resolver.openInputStream(uri)
            val byteArrayOutputStream = ByteArrayOutputStream()
            val buffer = ByteArray(1024)
            var bytesRead: Int

            while (inputStream?.read(buffer).also { bytesRead = it ?: -1 } != -1) {
                byteArrayOutputStream.write(buffer, 0, bytesRead)
            }

            val bytes = byteArrayOutputStream.toByteArray()
            Base64.encodeToString(bytes, Base64.DEFAULT)
        } catch (e: Exception) {
            //   e.printStackTrace()
            null
        }
    }
}    