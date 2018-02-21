package gr.auth.hci.lakouva;

import android.app.FragmentTransaction;
import android.graphics.Bitmap;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Config;

import com.android.volley.RequestQueue;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.google.android.gms.common.api.Response;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapFragment;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.StringReader;
import java.util.ArrayList;

public class MapsActivity extends AppCompatActivity implements OnMapReadyCallback {

    private MapFragment mapFragment;
    private MapFragment mMapFragment;

    private ArrayList<LatLng> locations;
    private JSONArray result;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_maps);

        mMapFragment = MapFragment.newInstance();
        FragmentTransaction fragmentTransaction =
                getFragmentManager().beginTransaction();
        fragmentTransaction.add(R.id.map, mMapFragment);
        fragmentTransaction.commit();

    }


    @Override
    protected void onResume() {
        super.onResume();
        mapFragment = (MapFragment) getFragmentManager()
                .findFragmentById(R.id.map);
        mapFragment.getMapAsync(this);
    }

    @Override
    public void onMapReady(GoogleMap googleMap) {
        LatLng lastloc = new LatLng(MainActivity.mCurrentLocation.getLatitude(),MainActivity.mCurrentLocation.getLongitude());
        for (MainActivity.LocationData locdata: MainActivity.locations) {
            LatLng pothole = new LatLng(locdata.getLatitude(),locdata.getLongitude());
            googleMap.addMarker(new MarkerOptions()
                    .position(pothole)
                    .title(locdata.getType())
                    .snippet(locdata.getName()));
        }
        googleMap.moveCamera(CameraUpdateFactory.newLatLng(lastloc));
        googleMap.moveCamera(CameraUpdateFactory.zoomTo(17));

    }
}
