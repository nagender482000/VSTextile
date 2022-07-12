package co.vstextile

import android.os.Bundle
import android.os.PersistableBundle
import com.google.firebase.FirebaseApp
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
        FirebaseApp.initializeApp(this);
    }

}
