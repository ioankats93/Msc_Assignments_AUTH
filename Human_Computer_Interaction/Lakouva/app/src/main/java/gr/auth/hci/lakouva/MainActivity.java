package gr.auth.hci.lakouva;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.ProgressDialog;
import android.content.Intent;
import android.content.IntentSender;
import android.content.pm.PackageManager;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.location.Location;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ToggleButton;

import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.google.android.gms.common.api.ResolvableApiException;
import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.location.LocationSettingsRequest;
import com.google.android.gms.location.LocationSettingsResponse;
import com.google.android.gms.location.SettingsClient;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import static java.lang.Math.abs;

public class MainActivity extends AppCompatActivity implements SensorEventListener {

    private TextView Longitude, Latitude, pothole, localCounter, globalCounter;
    private Sensor mySensor;
    private SensorManager SM;
    private FusedLocationProviderClient mFusedLocationClient;
    private OnSuccessListener<Location> listener;
    public static Location mCurrentLocation;
    private LocationRequest mLocationRequest;
    private LocationCallback mLocationCallback;
    public boolean mRequestingLocationUpdates = true;

    public static ArrayList<LatLng> locList;
    public static ArrayList<LocationData> locations;
    private static final String REQUESTING_LOCATION_UPDATES_KEY = "key";

    private EditText editTextname;
    private ImageButton gmaps;
    private ToggleButton toggle ;
    private boolean flag ;
    private boolean pause ;
    private JSONArray result;
    private static final String REGISTER_URL = "http://zachtsou.webpages.auth.gr/register.php";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        addListenerOnButton();
        getData();
        pause = false ;
        toggle = (ToggleButton) findViewById(R.id.toggleButton2);
        toggle.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked){
                    //The toggle is enabled
                    pause = true;
                }else{
                    // The toggle is disabled
                    pause = false;
                }
            }
        });

        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            // TODO: Consider calling
            //    ActivityCompat#requestPermissions
            // here to request the missing permissions, and then overriding
            //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
            //                                          int[] grantResults)
            // to handle the case where the user grants the permission. See the documentation
            // for ActivityCompat#requestPermissions for more details.

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION}
                        , 10);
            }
        }

        Longitude = findViewById(R.id.longitude);
        Latitude = findViewById(R.id.latitude);
        pothole = findViewById(R.id.pothole);
        localCounter = findViewById(R.id.localCounter);
        globalCounter = findViewById(R.id.globalCounter);
        editTextname = (EditText) findViewById(R.id.editTextname);
        flag = true ;
        locList = new ArrayList<>();
        locations = new ArrayList<LocationData>();

        // Create our Sensor Manager
        SM = (SensorManager) getSystemService(SENSOR_SERVICE);

        // Accelerometer Sensor
        mySensor = SM.getDefaultSensor(Sensor.TYPE_LINEAR_ACCELERATION);

        // Register sensor Listener
        SM.registerListener(this, mySensor, SensorManager.SENSOR_DELAY_NORMAL);

        mFusedLocationClient = LocationServices.getFusedLocationProviderClient(this);

        listener = new OnSuccessListener<Location>() {
            @Override
            public void onSuccess(Location location) {
                // Got last known location. In some rare situations this can be null.
                if (location != null) {
                    // Logic to handle location object
                    mCurrentLocation = location;
                    startLocationUpdates();
                }
            }
        };

        mLocationRequest = new LocationRequest();
        mLocationRequest.setInterval(5000);
        mLocationRequest.setFastestInterval(5000);
        mLocationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);

        LocationSettingsRequest.Builder builder = new LocationSettingsRequest.Builder()
                .addLocationRequest(mLocationRequest);

        SettingsClient client = LocationServices.getSettingsClient(this);
        Task<LocationSettingsResponse> task = client.checkLocationSettings(builder.build());

        task.addOnSuccessListener(this, new OnSuccessListener<LocationSettingsResponse>() {
            @Override
            public void onSuccess(LocationSettingsResponse locationSettingsResponse) {

            }
        });

        task.addOnFailureListener(this, new OnFailureListener() {
            @Override
            public void onFailure(@NonNull Exception e) {
                if (e instanceof ResolvableApiException) {
                    // Location settings are not satisfied, but this can be fixed
                    // by showing the user a dialog.
                    try {
                        // Show the dialog by calling startResolutionForResult(),
                        // and check the result in onActivityResult().
                        ResolvableApiException resolvable = (ResolvableApiException) e;
                        resolvable.startResolutionForResult(MainActivity.this,
                                65535);
                    } catch (IntentSender.SendIntentException sendEx) {
                        // Ignore the error.
                    }
                }
            }
        });

        mLocationCallback = new LocationCallback() {
            @Override
            public void onLocationResult(LocationResult locationResult) {
                if (locationResult.getLastLocation() != null) {
                    mCurrentLocation = locationResult.getLastLocation();
                    // Update UI with location data
                    // ...
                }
            }
        };

        localCounter.setText(String.valueOf(locList.size()));
    }

    // FETCH DATA
    private void getData(){
        //Creating string request
        StringRequest stringRequest = new StringRequest(Config.DATA_URL,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        JSONObject j = null;
                        try {
                            // PArsing the fetched Json String to Json object
                            j = new JSONObject(response);

                            // Storing the Array of Json String to our Json Array
                            result = j.getJSONArray(Config.JSON_ARRAY);

                            // Calling method get+ to get the Locations from the Json Array
                            getDBLocations(result);
                            globalCounter.setText(String.valueOf(locations.size()));
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {

                    }
                });
        // Creating a request queue
        RequestQueue requestQueue = Volley.newRequestQueue(this);

        // Adding request to the queue
        requestQueue.add(stringRequest);
    }

    public class LocationData {

        private String name;
        private String type;
        private double latitude;
        private double longitude;

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public double getLongitude() {
            return longitude;
        }

        public void setLongitude(double longitude) {
            this.longitude = longitude;
        }

        public double getLatitude() {
            return latitude;
        }

        public void setLatitude(double latitude) {
            this.latitude = latitude;
        }

        public String getType() {
            return type;
        }

        public void setType(String type) {
            this.type = type;
        }

    }
    private void getDBLocations(JSONArray j){
        locations.clear();
        // Traversing through all the items in the Json array
        for(int i=0;i<j.length();i++){
            try{
                LocationData location = new LocationData();
                //Getting json object
                JSONObject json = j.getJSONObject(i);

                // Adding types to array list
                location.setName(json.getString(Config.TAG_NAME));
                location.setType(json.getString(Config.TAG_TYPE));
                location.setLongitude(json.getDouble(Config.TAG_LONGITUDE));
                location.setLatitude(json.getDouble(Config.TAG_LATITUDE));

                locations.add(location);
            }catch (JSONException e){
                e.printStackTrace();
            }

        }
    }

    @SuppressLint("MissingPermission")
    @Override
    protected void onResume() {
        super.onResume();
        if (mRequestingLocationUpdates) {
            mFusedLocationClient.getLastLocation()
                    .addOnSuccessListener(this, listener);
        }
        localCounter.setText(String.valueOf(locList.size()));
        globalCounter.setText(String.valueOf(locations.size()));
    }

    @SuppressLint("MissingPermission")
    private void startLocationUpdates() {
        mFusedLocationClient.requestLocationUpdates(mLocationRequest,
                mLocationCallback,
                null /* Looper */);
    }

    @Override
    public void onSensorChanged(final SensorEvent event ) {
        if (pause) {
            if ((abs(event.values[0]) + abs(event.values[1]) + abs(event.values[2])) > 5 && (abs(event.values[0]) + abs(event.values[1]) + abs(event.values[2])) < 10) {
                LatLng loc = new LatLng(mCurrentLocation.getLatitude(), mCurrentLocation.getLongitude());
                flag = true;
                pothole.setText("Small Pothole");
                if (!locList.contains(loc)) {
                    locList.add(loc);
                    localCounter.setText(String.valueOf(locList.size()));
                    Longitude.append("\n " + loc.longitude);
                    Latitude.append("\n " + loc.latitude);
                    sentLocation(loc, flag);
                }
            } else if ((abs(event.values[0]) + abs(event.values[1]) + abs(event.values[2])) > 10) {
                LatLng loc = new LatLng(mCurrentLocation.getLatitude(), mCurrentLocation.getLongitude());
                flag = false;
                pothole.setText("Big Pothole");
                if (!locList.contains(loc)) {
                    locList.add(loc);
                    Longitude.append("\n " + loc.longitude);
                    Latitude.append("\n " + loc.latitude);
                    sentLocation(loc, flag);
                }
            }
        }
    }

    // Sent to DB
    private void sentLocation(LatLng loc , boolean flag)  {
        String type ;
        String name = editTextname.getText().toString().trim().toLowerCase();
        double longitude = loc.longitude;
        double latitude = loc.latitude;
        if (flag){
            type = "Small_Pothole";
        }else {
            type = "Big_Pothole";
        }

        sent(name, longitude, latitude, type);
    }
    private void sent(String name, double longitude, double latitude, String type) {
        String urlSuffix = "?name=" + name + "&longitude=" + longitude + "&latitude=" + latitude + "&type=" + type ;

        class Registerloc extends AsyncTask<String, Void, String>{

            ProgressDialog loading ;

            @Override
            protected void onPreExecute(){
                super.onPreExecute();
                loading = ProgressDialog.show(MainActivity.this, "Posting Location", null, true, true);
            }
            @Override
            protected void onPostExecute(String s){
                super.onPostExecute(s);
                loading.dismiss();
                Toast.makeText(getApplicationContext(), s, Toast.LENGTH_LONG).show();
            }
            @Override
            protected String doInBackground(String... params){
                String s = params[0];
                BufferedReader bufferedReader = null;
                try{
                    URL url = new URL(REGISTER_URL + s);
                    HttpURLConnection con = (HttpURLConnection) url.openConnection();
                    bufferedReader = new BufferedReader(new InputStreamReader(con.getInputStream()));

                    String result;

                    result = bufferedReader.readLine();
                    return result;
                }catch (Exception e) {
                    return null ;
                }
            }
        }
        Registerloc rl = new Registerloc();
        rl.execute(urlSuffix);
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {
        // Not is use
    }

    @SuppressLint("MissingPermission")
    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        switch (requestCode) {
            case 10:

                if (grantResults.length > 0
                        && grantResults[0] != PackageManager.PERMISSION_GRANTED) {

                    // permission was not granted.
                    ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION}
                            , 10);
                }
                break;
            default:
                break;
        }
    }

    public void addListenerOnButton(){
        gmaps = (ImageButton) findViewById(R.id.gmaps);
        gmaps.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {Intent intent = new Intent(MainActivity.this, MapsActivity.class);
                getData();   //Toast Error - get type if type big then red pin else yellow pin
                startActivity(intent);
            }
        });
    }



}
